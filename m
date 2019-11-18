Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 913A1100D36
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 21:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfKRUjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 15:39:31 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46610 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726568AbfKRUjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 15:39:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574109570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5HFQIq/y1ZCp71Y0vZlJywkPQZ5p4lRTYkmnopmNpHA=;
        b=G5FeH2qcMJg2/Ie2Vxec+W9iYGUojvrd2VefkVxbnTrxKYQHE6QSP8LrJnfiJgXmMDLKjo
        feAjEj/84Vs2ALEyEXqvczXLersTKz5sHClXZjCzn9pCzSQjZk0qTwIQRL23ODOgws26e/
        JOp3d8aecKLm/pDbNU/UBm5kS7TRC+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-1_qpRhNePniHRwJ-mdcf6A-1; Mon, 18 Nov 2019 15:39:24 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD6E41005500;
        Mon, 18 Nov 2019 20:39:22 +0000 (UTC)
Received: from dhcp-25.97.bos.redhat.com (unknown [10.18.25.127])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 356E25090C;
        Mon, 18 Nov 2019 20:39:21 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, ovs dev <dev@openvswitch.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] openvswitch: support asymmetric conntrack
References: <20191108210714.12426-1-aconole@redhat.com>
        <CAOrHB_B1ueESwUQSkb7BuFGCCyKKqognoWbukTHo2jTajNca6w@mail.gmail.com>
Date:   Mon, 18 Nov 2019 15:39:20 -0500
In-Reply-To: <CAOrHB_B1ueESwUQSkb7BuFGCCyKKqognoWbukTHo2jTajNca6w@mail.gmail.com>
        (Pravin Shelar's message of "Sat, 9 Nov 2019 14:15:31 -0800")
Message-ID: <f7twobwyl53.fsf@dhcp-25.97.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 1_qpRhNePniHRwJ-mdcf6A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pravin Shelar <pshelar@ovn.org> writes:

> On Fri, Nov 8, 2019 at 1:07 PM Aaron Conole <aconole@redhat.com> wrote:
>>
>> The openvswitch module shares a common conntrack and NAT infrastructure
>> exposed via netfilter.  It's possible that a packet needs both SNAT and
>> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
>> this because it runs through the NAT table twice - once on ingress and
>> again after egress.  The openvswitch module doesn't have such capability=
.
>>
>> Like netfilter hook infrastructure, we should run through NAT twice to
>> keep the symmetry.
>>
>> Fixes: 05752523e565 ("openvswitch: Interface with NAT.")
>> Signed-off-by: Aaron Conole <aconole@redhat.com>
>
> The patch looks ok. But I am not able apply it. can you fix the encoding.

Hrrm.  I didn't make any special changes (just used git send-email).  I
will look at spinning a second patch.


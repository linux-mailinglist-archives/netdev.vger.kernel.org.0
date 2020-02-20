Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3931663F9
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 18:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgBTRHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 12:07:51 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50956 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728768AbgBTRHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 12:07:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582218467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fRyl+HNCJYGuzif7UHbBNmoq+TguvgwSchvSmXTT2m8=;
        b=giUHMUtfIAB0HemHQWmprLxqBb5rPV6Kp6+MEPN2dWwBtGo+ZL3ggisJjLdiIw6hkntwNn
        e+FBi/TY/0gbeligtFHiyER+7m3jhFhm7o1HaF+crlbQfXQ+6jbu1y3waJi/baKoCcM8AU
        BCIczJnJFZMJDaimAuasbIm+PHZ00Uw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-o5UPWaBQMDeQ-SMDPVJK3A-1; Thu, 20 Feb 2020 12:07:44 -0500
X-MC-Unique: o5UPWaBQMDeQ-SMDPVJK3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3649800EB4;
        Thu, 20 Feb 2020 17:07:38 +0000 (UTC)
Received: from redhatnow.users.ipa.redhat.com (ovpn-117-1.phx2.redhat.com [10.3.117.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A06D90F65;
        Thu, 20 Feb 2020 17:07:29 +0000 (UTC)
Subject: Re: [RFC PATCH 02/11] ata: Remove Calxeda AHCI driver
To:     Rob Herring <robh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
References: <20200218171321.30990-1-robh@kernel.org>
 <20200218171321.30990-3-robh@kernel.org>
From:   Mark Langsdorf <mlangsdo@redhat.com>
Message-ID: <bf1291f2-597e-bff9-6780-ec233f5c2a20@redhat.com>
Date:   Thu, 20 Feb 2020 11:07:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218171321.30990-3-robh@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 11:13 AM, Rob Herring wrote:
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: linux-ide@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---

Acked-by: Mark Langsdorf <mark.langsdorf@gmail.com>


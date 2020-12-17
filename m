Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F87D2DDA52
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 21:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731475AbgLQUv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 15:51:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727055AbgLQUv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 15:51:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608238203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zpxb228cqv5O2zJNyq8lKwTFP9FllxQ5x+iK2PIl8Fs=;
        b=Xqr9X3BQBkqTnhoieUAwaSpuNjR9lOfCz6BsM9qT8h1oyvez7zT5tDerF+TpZDFHmKOjUr
        CAmJkn3FVaoBbGaPFCRtRiNZVmMzgHY5obKPu8nsbkaQwPfFTteeCS68e0fj0upE4hMtAx
        jOaW9jMx1MaFBkKEV95gn9q5Uo19on0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-hd8qCKXUNSORFg3-NbkaUw-1; Thu, 17 Dec 2020 15:49:59 -0500
X-MC-Unique: hd8qCKXUNSORFg3-NbkaUw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FF0E8049C6;
        Thu, 17 Dec 2020 20:49:57 +0000 (UTC)
Received: from [10.40.194.68] (unknown [10.40.194.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E64B95D9CD;
        Thu, 17 Dec 2020 20:49:54 +0000 (UTC)
Message-ID: <bceb3a36a904a711e4416ba51c266700ffb5f72c.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: sch_taprio: reset child qdiscs before
 freeing them
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
In-Reply-To: <20201217124504.561c67c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com>
         <20201217110531.6fd60fe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <786e7a967a73f29995107412bc3506daf657c29a.camel@redhat.com>
         <20201217124504.561c67c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 17 Dec 2020 21:49:53 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-12-17 at 12:45 -0800, Jakub Kicinski wrote:
> Right, but that's init, look at taprio_graft(). The child qdiscs can be
> replaced at any time. And the replacement can be NULL otherwise why
> would graft check "if (new)"

good point, you are right. I'll send a follow-up patch right now.
thanks!

--  
davide


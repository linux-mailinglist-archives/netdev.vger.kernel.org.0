Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8A547C389
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 17:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239547AbhLUQKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 11:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239532AbhLUQKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 11:10:25 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA99C061574;
        Tue, 21 Dec 2021 08:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=bICMg/jGREnxSL2NhCs04DnCL90eeKDc3sev2BLi86A=;
        t=1640103025; x=1641312625; b=dkFWgvbLK2U8mfXmjV7b8rLHHpNRbmqaZKqhfCHxBTvkU9w
        7Jjd/vnJaj+FI/EEGyxcycm5Zv5BhuHnUhBgDqR1ey0HD4IAk6M1Ob+w+rc6yKxdSqlaGUnfVMhhq
        gK6bIzsBuhRwb6IK8EK3UmNuBrlDYoTOIuIleJf0IKT+v/TG8KvTf3ShQkeVR3EFEXsWQlOR4Oqkr
        IZ+NAjGXED4imOMYk+MwAx2uSAORlewhMbpFa4mVe0FkSFZL7eNqWcI3Y5AzG7gmkrj2uag+rqiKZ
        cxFNeCpeCxdA8bo/frZ+PbicSAbAfooxLVNbiONStMhom+qIOKcql9x0xCFLoYrg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mzhiY-00Edp9-HB;
        Tue, 21 Dec 2021 17:10:22 +0100
Message-ID: <d20c7377a6f22c82c0e61f7916f454f13bbea15b.camel@sipsolutions.net>
Subject: Re: pull-request: mac80211-next 2021-12-21
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Tue, 21 Dec 2021 17:10:21 +0100
In-Reply-To: <20211221080700.3554579d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211221112532.28708-1-johannes@sipsolutions.net>
         <20211221080700.3554579d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-12-21 at 08:07 -0800, Jakub Kicinski wrote:
> 
> Thanks for the links, pulled.
> 
Thanks.

> > Please pull and let me know if there's any (further) problem.
> 
> There was one faulty Fixes tag in there, FWIW.
> 
Hmm. Indeed, I see, sorry about that! I guess I must've done something
stupid with that, not really sure now, apparently I applied that
original commit bc2dfc02836b ("cfg80211: implement APIs for dedicated
radar detection HW") about a month ago. Sorry.

johannes


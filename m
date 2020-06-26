Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E51A20B6D8
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgFZRXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:23:35 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:42511 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZRXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:23:35 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        by serv108.segi.ulg.ac.be (Postfix) with ESMTP id 3907B200BE49;
        Fri, 26 Jun 2020 19:23:21 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 3907B200BE49
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1593192201;
        bh=Va7iAIp1xA9kpdT0725iMd4BkKknTky8Aqt0+BaTvLk=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=CTMciWYP2nm3DM8vgFdaSy87+VqfyvN31pAu/pbzz9hELTw87cIItuPaYTZBE2bUi
         JpyHqzvGnNYKXBzMBHEXFcN+EiaKYtHHtu576jx7Adf7zZGle88xPt4EYIZy1mN8+I
         Cyg4hxYxcAmMzTqphuIPxqpcGevjj0vibPOr4vf57hoawmf96Vygbx6jcC7olOZbS0
         AsYZMyxwnP7L+BbEF7pJX7aPMTfMS8IMFcguvUHPcNvB1HrLgwkzFC/MTT51pF8vVs
         RE9AbYTbCXgzUejKcO6yo/pUjxp/7d4VzYdBEXe7Ls12LzIVipjxTCe9bPRQkQ0Kwb
         SsC+xfkSt+rmA==
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 2BEFC129EBC9;
        Fri, 26 Jun 2020 19:23:21 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Nx6Z8Ch-h_In; Fri, 26 Jun 2020 19:23:21 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 10AB4129EBC8;
        Fri, 26 Jun 2020 19:23:21 +0200 (CEST)
Date:   Fri, 26 Jun 2020 19:23:21 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dan carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org,
        netdev@vger.kernel.org, lkp@intel.com, kbuild-all@lists.01.org,
        davem@davemloft.net
Message-ID: <1079923894.37655623.1593192201005.JavaMail.zimbra@uliege.be>
In-Reply-To: <20200626090125.7ae41142@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200625105237.GC2549@kadam> <20200626085435.6627-1-justin.iurman@uliege.be> <20200626090125.7ae41142@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [PATCH net-next] Fix unchecked dereference
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.129.49.166]
X-Mailer: Zimbra 8.8.15_GA_3901 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3895)
Thread-Topic: Fix unchecked dereference
Thread-Index: a45vs74gCn2RNhDfhMr2f0SJat7eWA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

It is an inline modification of the patch 4 of this series. The modification in itself cannot be a problem. Maybe I did send it the wrong way?

Justin

>> If rhashtable_remove_fast returns an error, a rollback is applied. In
>> that case, an unchecked dereference has been fixed.
>> 
>> Reported-by: kernel test robot <lkp@intel.com>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> 
> My bot says this doesn't apply to net-next, could you double-check?

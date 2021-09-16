Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3B440EB85
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 22:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238406AbhIPUTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 16:19:19 -0400
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:39992
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhIPUTS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 16:19:18 -0400
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2021 16:19:18 EDT
Received: from p3plcpnl1062.prod.phx3.secureserver.net ([50.62.161.131])
        by : HOSTING RELAY : with ESMTP
        id QxhHmABAKNpW3QxhHmtvBP; Thu, 16 Sep 2021 13:09:27 -0700
X-CMAE-Analysis: v=2.4 cv=IsXbzJzg c=1 sm=1 tr=0 ts=6143a477
 a=dUVmeoHZULcvEZmpJC9XRQ==:117 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10 a=7y478MxDpPYA:10
 a=Vk7GA2kSAv4A:10 a=7QKq2e-ADPsA:10 a=2tQCi5rtVpkA:10 a=M51BFTxLslgA:10
 a=VwQbUJbxAAAA:8 a=401QvYogAAAA:8 a=oETo95l8tDZVEtLRtccA:9 a=QEXdDO2ut3YA:10
 a=BSHFW6nFAgUA:10 a=-YubsuZ0-RQA:10 a=qHuryBgDqF0A:10 a=NWVoK91CQyQA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=NijDbifxZE5DWIws8XhU:22
X-SECURESERVER-ACCT: fvegn7a7sey2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=p3plcpnl1062.prod.phx3.secureserver.net; s=default;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:From:Date:
        Subject:To:Sender:Reply-To:Cc:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
        References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
        List-Owner:List-Archive; bh=hx0ClTgfRQ83MANuPp2Ce6cn5gOsz/b3voDPgnDTHWg=; b=M
        xsw1ZHY4tE6tbIBVdUQOX890dQhzpdyrGZPcRfvX/AlWfW/3YuIgdLYBsBrmwFyn+K+eHLaO/P9BI
        tDY/Z2T1oDF7AT7mZLDoKFKQLSgqq6BR8+Sf8e2wFRApUyP4r5o6rrGco10eFSFTp8WlUtXvkulEv
        01msu3gsDKSdohDxW15uAUo8DDP62f/NweMviYq9FvowzZpakBBMCPHjtDrI9Z3tpRduGLagPUbSp
        NMm0SCuEdRlAijkzxorSuSdIMnC3wxzdcAYMNrC66BMMvI+UepNKrwOxp3YTI+7oUYlR5EEAbCHra
        wkhdSbztHCj2YhI7VBDPoJT+L6l/yzfkQ==;
Received: from fvegn7a7sey2 by p3plcpnl1062.prod.phx3.secureserver.net with local (Exim 4.93)
        (envelope-from <fvegn7a7sey2@p3plcpnl1062.prod.phx3.secureserver.net>)
        id 1mQxhH-005CTx-Nd
        for netdev@vger.kernel.org; Thu, 16 Sep 2021 13:09:27 -0700
To:     netdev@vger.kernel.org
Subject: You emailed Team-Kennedy ES
X-PHP-Script: team-kennedy.com/es/index.php for 103.94.181.118
X-PHP-Filename: /home/fvegn7a7sey2/public_html/es/index.php REMOTE_ADDR: 103.94.181.118
Date:   Thu, 16 Sep 2021 20:09:27 +0000
From:   =?UTF-8?B?5r6z6Zeo6YeR5rKZwrfms6jlhozpgIEzOA==?= 
        <info@team-kennedy.com>
Message-ID: <fed3dfb669145cc400d6d24bf81cdf76@team-kennedy.com>
X-Mailer: PHPMailer 5.2.22 (https://github.com/PHPMailer/PHPMailer)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - p3plcpnl1062.prod.phx3.secureserver.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [7831253 963] / [47 12]
X-AntiAbuse: Sender Address Domain - p3plcpnl1062.prod.phx3.secureserver.net
X-Get-Message-Sender-Via: p3plcpnl1062.prod.phx3.secureserver.net: authenticated_id: fvegn7a7sey2/from_h
X-Authenticated-Sender: p3plcpnl1062.prod.phx3.secureserver.net: info@team-kennedy.com
X-Source: 
X-Source-Args: 
X-Source-Dir: team-kennedy.com:/public_html/es
X-CMAE-Envelope: MS4xfKDm8OtVEPz9zTSmeevC/pU0YTCJigjXHBZuEpJlSpabcxfjVQrRUJ/TsnzVmN71UW28Fyaa7rzml56Pcg/fSuTMPVJnXJeCF2jIKBEpChIlTmzTavuk
 0WhMoyvGrj19nM69BYFBKB3glnebzgTXzPFk94yrn5qTtEUtOS5ip2fjbJiUjdrJVCukXt7CnbmfjPuyZzfso2ls57eArlvmDhgScx08eLVawc6HSzuiCSr4
 LQJto/WvGeY3eYvMlM6RQFsqmNkt00K/PIQ14NyOv3A=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Name: 澳门金沙·注册送38 

Email: netdev@vger.kernel.org 

Comments: 2021年相约【澳门金沙】：www.2220386.com/? 共享激情联赛，注册即送38，首充1000送88。+乐乐QQ:2018177429 QQ:2012312059 咨询
----------
既富以强。谓公吾父，孰违公令。可以师征，不宁守邦。 
尊酒相逢十载前，君为壮夫我少年。尊酒相逢十载后，


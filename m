Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780712C932A
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388954AbgK3XvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388938AbgK3XvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 18:51:21 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EE4C0613CF;
        Mon, 30 Nov 2020 15:50:34 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id m19so7ejj.11;
        Mon, 30 Nov 2020 15:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7lMOOQvdqUOwbmtdKr6S/nixjPck0Pwdn/gtL9VI6pQ=;
        b=d7hrqtIX+xD1eLtp3cpukvwZw7frT0tnMk2ESj3/te+5f+ZeX3TSOvvu2+d4XLulQr
         HzLy37RAAF0jeF/ab8wC6QdQau9pl2lI4ClH9JcLEG+PuCNM9b8MpLdI1W/werBEUHBu
         42GpgWLyQE4UA8gHcjn+bTWo6cn569iUd+EYi3VeCSxE754cHdA4NrzSO98iZBSXExSN
         TuYNpuP3Ot0OaphuamPpbcylLgsKovGRORl3jV1oPegMcIIxfMmSX8bmnEEkTXLDcEeI
         t3NBvf11yIuFlUPDJK2FM71zhLqMau5UnZJKaXYzhGE/T5lebLLeeSa4V3uuCJvnrf9a
         gksg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7lMOOQvdqUOwbmtdKr6S/nixjPck0Pwdn/gtL9VI6pQ=;
        b=kYRK+rlSAP3/AYg1LaviGTdoXAvG9BqoiQQPTiH0f+xczxxwoGg/LOZDBBhJLiGdO2
         w2el47y6mGB0AlzEuuCC1VSuq01fnsF1sOPu6/BO7eNpASfLxpSauarC6F+YIkvc+Ail
         xZL//LQrm5tJLkr7gaNsXS59WnDxdPpXmq1zR0MYplRGNZkDo/zXhqz3VumEFbw1z7zS
         dvSYf8fyANmWJaEJ3F38JUeo/VoB9ikvmIkhkuMYZyxxUA5RuV2m0eXf3pi9b/ORLgQR
         aJA5zaUtViy8o8CJZHXrqi2Rpa6NGIDy+30UVnt98ghILma1kyCwsLE0IOl9zuqq1nPD
         rQQQ==
X-Gm-Message-State: AOAM532jxIYdI1DToZ8RtlkMd+Tn9hLSMJl0s7PhMs5PHiWNs/bZuSps
        /1obLeCVqvSHYoDJOTd6QHE=
X-Google-Smtp-Source: ABdhPJyah5jSLWu0szzqBIn+FZ3jf4pFwB3v1WwO2+ktPNmZ/OSOh8vZZwZyaasnNS55iogpMHm3tg==
X-Received: by 2002:a17:906:60d2:: with SMTP id f18mr261836ejk.528.1606780233136;
        Mon, 30 Nov 2020 15:50:33 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id d14sm3000347edn.31.2020.11.30.15.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 15:50:32 -0800 (PST)
Date:   Tue, 1 Dec 2020 01:50:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201130235031.cdxkp344ph7uob7o@skbuf>
References: <20201127195057.ac56bimc6z3kpygs@skbuf>
 <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
 <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127233048.GB2073444@lunn.ch>
 <20201127233916.bmhvcep6sjs5so2e@skbuf>
 <20201128000234.hwd5zo2d4giiikjc@skbuf>
 <20201128003912.GA2191767@lunn.ch>
 <20201128014106.lcqi6btkudbnj3mc@skbuf>
 <20201127181525.2fe6205d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=O-TDPax1smCPq=b1w3SVqJokesWx02AUGUXD0hUwXbAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=O-TDPax1smCPq=b1w3SVqJokesWx02AUGUXD0hUwXbAg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 10:52:35AM -0600, George McCollister wrote:
> Another possible option could be replacing for_each_netdev_rcu with
> for_each_netdev_srcu and using list_for_each_entry_srcu (though it's
> currently used nowhere else in the kernel). Has anyone considered
> using sleepable RCUs or thought of a reason they wouldn't work or
> wouldn't be desirable? For more info search for SRCU in
> Documentation/RCU/RTFP.txt

Want to take the lead?

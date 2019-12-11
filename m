Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0904311A0FC
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 03:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfLKCCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 21:02:07 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:45210 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfLKCCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 21:02:06 -0500
Received: by mail-qv1-f65.google.com with SMTP id c2so5063713qvp.12
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 18:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=hnNNPiH+0knQ/mTzZcYqFPWlCiT6PxlNTbmMZNe9cuI=;
        b=CI3y8NjAcg4RuMdoysRTliQdCeFvnlTn3p4r4x7yyAAOTht5S99FivoTPRLD2MDFgo
         yxxfP8bkP5M783hKAt0Y2mE0zBxFbKk5T+qtv//4r0NWBgGg7CbWnkFyXo76JY/3ir98
         ZaFXjOWNpKYKsviYRW5E4Mkvf7a0PxmZbCcyIL28oecPLTlC6T4BOvPZVlyOA2tc7AMQ
         2UK02IKwVa/8SuWn7sKGQNMX0q9z5btI9udvmazi4E7UBDsUnf0Cijw+m9a7qRNsZ29r
         BQJDqPg60OSZkIkh9p9o+0px5NEz9Tp4MhGVpG2Bc+rpIgZDrNTPXQoROmm3drwsvH1i
         ac2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=hnNNPiH+0knQ/mTzZcYqFPWlCiT6PxlNTbmMZNe9cuI=;
        b=gUMZZ/aeE8rc/4w2Kus7okZfpmuAoUeWSyB95prqeh+Ur/XOPQX6+ZSrwqySULMcTP
         lBOJKxcWdwPDB4LF1etk43Nz1cQNoJ1EK1n/Qq0H594pgrlypugjbzma+feYrTR1ADkc
         Vj5WiMtl3wd8WvdfknrmZxa65E3MJSOGBiJ5kBVZsih7zklxUaKcsMdZ0al7ArDZmkgJ
         8sfrK3wlJBsjXFAAd/RwmE5r40EZmV8un17jjZmFcpRrETzOhd4MQcAWcApMp584AhJu
         owRvAIk9rByU4rJs6oJafoak7RlBIo549p+4iFZmbmfsP8SsGHNaj+zAdRnjaHU30fob
         gWXw==
X-Gm-Message-State: APjAAAUL8AtTH+u4f8JWXleho7/QF7CgfrhSHGMJ4JjsaY/qvDm8ZCIN
        onjC9GYH+Q7uipv1SBfVY3ankAEm
X-Google-Smtp-Source: APXvYqySIaUEAShOwMQtJMFxIMCwEiclUKMGXfuVcM+sbrtE7tZdTWcWpaiYsp87aE34pSfNl+tZ4g==
X-Received: by 2002:a05:6214:3a1:: with SMTP id m1mr808145qvy.77.1576029725576;
        Tue, 10 Dec 2019 18:02:05 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 184sm167242qke.73.2019.12.10.18.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 18:02:04 -0800 (PST)
Date:   Tue, 10 Dec 2019 21:02:03 -0500
Message-ID: <20191210210203.GB1480973@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next v2] net: bridge: add STP xstats
In-Reply-To: <30e93cfb-cc2c-c484-a743-479cce19d8a9@cumulusnetworks.com>
References: <20191210212050.1470909-1-vivien.didelot@gmail.com>
 <30e93cfb-cc2c-c484-a743-479cce19d8a9@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

On Tue, 10 Dec 2019 23:45:13 +0200, Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
> > +	if (p) {
> > +		nla = nla_reserve_64bit(skb, BRIDGE_XSTATS_STP,
> > +					sizeof(p->stp_xstats),
> > +					BRIDGE_XSTATS_PAD);
> > +		if (!nla)
> > +			goto nla_put_failure;
> > +
> > +		memcpy(nla_data(nla), &p->stp_xstats, sizeof(p->stp_xstats));
> 
> You need to take the STP lock here to get a proper snapshot of the values.

Good catch! I see a br->multicast_lock but no br->stp_lock. Is this what
you expect?

    spin_lock_bh(&br->lock);
    memcpy(nla_data(nla), &p->stp_xstats, sizeof(p->stp_xstats));
    spin_unlock_bh(&br->lock);


Thanks,

	Vivien

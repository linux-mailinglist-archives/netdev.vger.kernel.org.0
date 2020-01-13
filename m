Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C14D01393C0
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgAMOe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:34:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38428 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMOe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:34:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so8824340wrh.5
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 06:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OmcWfIBXkgyvN2cgft6r1ms+tR1sv2tTxJ3TL0EKA+g=;
        b=BjSBuIz0rqihO1u6oVG994zIp4LszvgfRyi3TQIDE9elXW2RNLXBA9Qa9hSk9WYUHp
         4evf6MYWH1Uk3c/DnxD20kDx5llyTzfvKjoYm575UEKChy+28T2/c/S2YoxHsMjFpemo
         zfyIuvsQ4up1UMLF2NkbUJWPej4HkVaUmNxpsQBBauf+TO0NA9FNfWzogkLx/Hfm142N
         L5pP4sAxO+x4dkQwdEgFDOngz+NMzpvqYmnc6FW9v/jp/bqgYAMAfATqx/VgozdgbTte
         4C/x5MLMYcsIojpEux8gaPd5/Yk2TLwM8fRV/J+4nbX//exFdx4bbwLzZx1m+YlxHAJE
         sQ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OmcWfIBXkgyvN2cgft6r1ms+tR1sv2tTxJ3TL0EKA+g=;
        b=LT1IukbIS043ylXqhOPUZhYy/PBJp3wtY5OAWDIxv/DGzWBmogBsMMqnyuV7Q30M8X
         ZhDcFTlMPBe9IdF8eA+jDevXOwRK/UJkcjv8a4PM1i9eOu7NLFLJasHBBrpnF9Qi/Yvg
         IcuuM3HxhlOm/UJvtAg+pR4I6ora2iwhZy/y/CEW6FscLsQT5s7u4y33nKrLguM9/NO9
         cqSASSLX5FPh3w+MzBCiYBQVUky1c2AfwZ6aSZqv4ziUtzOKQX249KyVCGo3vetsO726
         6SBh1NVZsCscLvoeIpNPNdm3kTm5Ux7mfu2wcpO264g6gsLzRF1owmEnGc8Zgxq1GWjd
         FY1A==
X-Gm-Message-State: APjAAAWUOI+UKHJSJys1fOcbLr63e7fk3K33+82SuNOESWPvxXJaleD1
        LUfmcE7tXiqAOg+khxee51DoS0o52yGkiQ==
X-Google-Smtp-Source: APXvYqzs5RfhHexyHDgfnn5rf2OytVWc6odXONn7jRukll8feWi5Dn5ZVX6pU3hEsY5aT/Q+0PfQmw==
X-Received: by 2002:a5d:66c3:: with SMTP id k3mr17870446wrw.370.1578926094258;
        Mon, 13 Jan 2020 06:34:54 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id l19sm14443297wmj.12.2020.01.13.06.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 06:34:53 -0800 (PST)
Date:   Mon, 13 Jan 2020 15:34:52 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v5 05/15] net: macsec: hardware offloading
 infrastructure
Message-ID: <20200113143452.GA2131@nanopsycho>
References: <20200110162010.338611-1-antoine.tenart@bootlin.com>
 <20200110162010.338611-6-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110162010.338611-6-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 10, 2020 at 05:20:00PM CET, antoine.tenart@bootlin.com wrote:

Couple nitpicks I randomly spotted:

[...]


>+static bool macsec_is_offloaded(struct macsec_dev *macsec)
>+{
>+	if (macsec->offload == MACSEC_OFFLOAD_PHY)
>+		return true;
>+
>+	return false;

Just:
	return macsec->offload == MACSEC_OFFLOAD_PHY;


>+}
>+
>+/* Checks if underlying layers implement MACsec offloading functions. */
>+static bool macsec_check_offload(enum macsec_offload offload,
>+				 struct macsec_dev *macsec)
>+{
>+	if (!macsec || !macsec->real_dev)
>+		return false;
>+
>+	if (offload == MACSEC_OFFLOAD_PHY)

You have a helper for this already - macsec_is_offloaded(). No need for
"offload" arg then.


>+		return macsec->real_dev->phydev &&
>+		       macsec->real_dev->phydev->macsec_ops;
>+
>+	return false;
>+}
>+
>+static const struct macsec_ops *__macsec_get_ops(enum macsec_offload offload,
>+						 struct macsec_dev *macsec,
>+						 struct macsec_context *ctx)
>+{
>+	if (ctx) {
>+		memset(ctx, 0, sizeof(*ctx));
>+		ctx->offload = offload;
>+
>+		if (offload == MACSEC_OFFLOAD_PHY)

Same here.


>+			ctx->phydev = macsec->real_dev->phydev;
>+	}
>+
>+	return macsec->real_dev->phydev->macsec_ops;
>+}
>+

[...]

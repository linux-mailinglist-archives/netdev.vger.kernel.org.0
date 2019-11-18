Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2229100E5F
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfKRVuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:50:12 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37702 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbfKRVuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 16:50:09 -0500
Received: by mail-lf1-f65.google.com with SMTP id b20so15143719lfp.4
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 13:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=6iEisswkww6icIvmueWMET5QsWfdd/ybzp6e7GAC5Co=;
        b=J0kSWmhUVRv/ogCumNEKUuGfnNjijWRe5pKw7IdOyJZZTTpUvX6QcD4M32ELIjT8QE
         dfrfPIHI6XdJb1xaEh6g4TZY9OUFBnt/4sfctshHqnJKhTNwA0c0+kpcUu8EB6+7Znb1
         vQqQMUlM9Cuc5Ebibk8S2E1VI+fnPv1fj/Q8etmrGTB+du1CHDU71H0lbUBDHjgqeoy2
         BDV/880tQYYLJgjFkLquffOZxaQ2+ve/SekrEH8kI9xsM0jz8arQemD+Qy7HY/LbK20U
         dAcjKUx8Nev/7T/uacRG0gSrf67LIAbbqoKNP4RQlPj/Sw3pP7Qnpn3qyt2fNfluH3Bt
         UChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=6iEisswkww6icIvmueWMET5QsWfdd/ybzp6e7GAC5Co=;
        b=I95gnxxY3LL0o40+J6b7V6p+QLSVwIY/TcqYuq9gBI4GHI89vsmY/v7n/5oENqhTOk
         pzCDjesKswHMgyviKMuwP/cMhxtTJf/IZ4DtFxZ9YKLUsXSMmwAr33H9cqJqt5VuJ+YJ
         YoDK+M+vuXIo5EQYpjBKG2QYy/MSdbYgnM9vts8mB273C6nvHmWKk7+fSREcwp+rEz5g
         25HsVcdOCoBpweZIc3pTHd8BCyQ6NLNJ/aoyLSe3HBLlbA6BePv/GTLtyimyf31/gZLT
         b6zJbTbPMXDhaR6qtb1bou6rPzAPs6mRt7E/N46O+J+76EdxgGp8XQnKoFsgnNLDWVnm
         eRSg==
X-Gm-Message-State: APjAAAVg+8zKtM6zc75XTHRcNzENFM+nWLxj2Z9HRcdhe0kxlGGlEzVk
        xhb2AQBBKrvjs1usy2MLuuJL9BUBEug=
X-Google-Smtp-Source: APXvYqxrccfzYhsJvWrrrZXyW3FTowCjEzJ2Su8cc0pAQ1uttXSLjwIIy5PBzlEKssYanKRnWwm5rQ==
X-Received: by 2002:a19:7510:: with SMTP id y16mr1135222lfe.24.1574113807792;
        Mon, 18 Nov 2019 13:50:07 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y9sm9382778lfl.16.2019.11.18.13.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 13:50:07 -0800 (PST)
Date:   Mon, 18 Nov 2019 13:49:55 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Christina Jacob <cjacob@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH 15/15] octeontx2-af: Support to get CGX link info like
 current speed, fec etc
Message-ID: <20191118134955.41b00c79@cakuba.netronome.com>
In-Reply-To: <1574007266-17123-16-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
        <1574007266-17123-16-git-send-email-sunil.kovvuri@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Nov 2019 21:44:26 +0530, sunil.kovvuri@gmail.com wrote:
> From: Christina Jacob <cjacob@marvell.com>
> 
> - Implements CGX_FW_DATA_GET command to get the cgx link info shared
>   from atf.
> - Implement CGX_FEC_SET mailbox message to set current FEC value.
> - Update the link status structre in cgx with additional information
>   such as the port type, current fec etc.
> - Upon request, fetch FEC corrected and uncorrected block counters
>   for the mapped CGX LMAC.
> - If present get phy's EEPROM data as response to ethtool command.

Again, confused about what this driver is doing. You talk about ethool
in the last point, but there's not ethtool hooked in here. More than
that:

net-next$ git grep ethtool -- drivers/net/ethernet/marvell/octeontx2/
net-next$

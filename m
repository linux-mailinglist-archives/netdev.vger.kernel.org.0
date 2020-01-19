Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E0E141E64
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 15:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgASOEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 09:04:04 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33083 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASOED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 09:04:03 -0500
Received: by mail-wr1-f67.google.com with SMTP id b6so26910444wrq.0;
        Sun, 19 Jan 2020 06:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Ocb2zugiLO+xET//21zhNLSukAYLvW1HhjzJze0PZFY=;
        b=XojgUu3qJDckuKraJoIHxKxWu+Q3CYMRjOdwV+B7NCNwAlwnrGuCMJDkTJlJxQpWpy
         tKi/1apRW/xl2lAsgjQO5i7y4OdT12sYiVT06ASHAy6YraMMmRm2qoY+KyZW+QDVNnwM
         EDmX4RtkVrdEm0OgAhUNenu8n8ALvSZHd4HHtOHHNfOz6+pjNei9E9UqVcbCSzHYinhW
         Qn/eBBNYpCc1GI1E5MdSWZMAGpeQKscYotaaJqKDV/+ybgvv7erslI5KHEB/dBgbLvcM
         mY4YU3v47Z5TxcBn29Gq++bPB27+Ce34Ov692BRIKk0cwRwT5RrLeZqcUDz0nQ4W3Q5T
         vLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Ocb2zugiLO+xET//21zhNLSukAYLvW1HhjzJze0PZFY=;
        b=bj41Qvveyox9R0o22iJfwtKQsabHbCPPOPCzLPtv4E10WBAKYOlB9hM5V6JnZaNenF
         YHAfnKqp+v72ELcj038mSBOFnZFv8NJb9Y5aOD8fOS6P93i4gy2UbBxERU0p7ZtYarxO
         J1UyjIW4vYbUu0tjjAgWTMdEbzEW+MRMTLsdvK9QNFpytln0zS04vDCkPMDbdrDtyvdA
         e5r5QL5op7MJu0S70+C85uwqkYKhOml7qIVG1Dd9/cWlraLKmd0jozZhVVEyyxA5BQii
         O8qyrd9OUYWOGGU4yUkHBSKSAWvcWKCAjtKcmBjkiwFHTdJSgV7u945TX6CrHqSowDcd
         PeZQ==
X-Gm-Message-State: APjAAAV1Q2p/Uj3GllIzLB7Wk6ZpocoN65x2unCSWCDE1RHwWC9IzGh4
        j8f8jGZMOBkv5r0YmQl9N0M=
X-Google-Smtp-Source: APXvYqyyqUUrY5OFgXLSFWeA7vOuLAz1xsvXt998I/Af2oxYL/hTVOxA+CtxjWqOqaeZnx7Fb+7zsg==
X-Received: by 2002:a5d:4687:: with SMTP id u7mr13127453wrq.176.1579442642464;
        Sun, 19 Jan 2020 06:04:02 -0800 (PST)
Received: from home ([141.226.244.232])
        by smtp.gmail.com with ESMTPSA id b67sm3649809wmc.38.2020.01.19.06.04.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 Jan 2020 06:04:01 -0800 (PST)
Date:   Sun, 19 Jan 2020 16:03:59 +0200
From:   Valery Ivanov <ivalery111@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: fix missing a blank line after declaration
Message-ID: <20200119140359.GA8668@home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes "WARNING: Missing a blank lin after declarations"
Issue found by checkpatch.pl

Signed-off-by: Valery Ivanov <ivalery111@gmail.com>
---
 drivers/staging/qlge/qlge_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index 56d116d79e56..2872b7120e36 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -412,6 +412,7 @@ static void ql_get_drvinfo(struct net_device *ndev,
 			   struct ethtool_drvinfo *drvinfo)
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
+
 	strlcpy(drvinfo->driver, qlge_driver_name, sizeof(drvinfo->driver));
 	strlcpy(drvinfo->version, qlge_driver_version,
 		sizeof(drvinfo->version));
@@ -703,12 +704,14 @@ static int ql_set_pauseparam(struct net_device *netdev,
 static u32 ql_get_msglevel(struct net_device *ndev)
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
+
 	return qdev->msg_enable;
 }
 
 static void ql_set_msglevel(struct net_device *ndev, u32 value)
 {
 	struct ql_adapter *qdev = netdev_priv(ndev);
+
 	qdev->msg_enable = value;
 }
 
-- 
2.17.1


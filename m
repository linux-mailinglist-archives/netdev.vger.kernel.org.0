Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4D821D599
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 14:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgGMMPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 08:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729143AbgGMMPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 08:15:20 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1164DC061755;
        Mon, 13 Jul 2020 05:15:20 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w2so5932178pgg.10;
        Mon, 13 Jul 2020 05:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CngMTDKicRpGsYdV84WEl9k2HNLxAMPDNQJc4li0NJg=;
        b=AKk8DOTp4rMxlJ8l4EPNhHU9SB8X1hd/H6jmMzRGlZuExBZ4jFqyrebmjVsUjbgI42
         fmy1YojOiOrzkQg2zhMnVYY9/sWERz9dqP4hZGPTmch0SyFbkQEKARm5Uabq3WDSaaUc
         bWb9ctloxEVOL83jY5b7GgpmtUanndBVO6qK0oFcZbaheYe/J+6UOWZKDsaNwrjVLjWv
         ncJj5KQaD5LknFiiCSgIWeiTfOe81ahB6XdxCf/+6XR5JvgWUHQQZDqhbhE0/Rev+mtd
         QoNXmhIqcV7uPND8T/M5bryq4CBi7R4lCVsofBVvrG3aRiAIhoTAbpH4phgaMIDPHMwT
         ZXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CngMTDKicRpGsYdV84WEl9k2HNLxAMPDNQJc4li0NJg=;
        b=A8xVhjUyfgyyU1nEooFhxNPM5f+YhRxm470h4WVYU/gUiY0HA1P4LWUtDWz0YJ2L/S
         kr85c3Hyq9UdB4Z18qweCvfKzKNF/zGTOWilhyzceMSNE2Zj1WhdUynffBLi5KjSWbh8
         XnacmEr2ulc1ZSgRr9F8/DrtRstjTI3FzXVK9Nq+q79dLVj2I2aYrbkObaStBMAcdFMo
         wWK4YE0jkbc2ZfaNW78wnee5MujJL6k5WqQwme91CUG0Z6MmJH2piKKVbGMAHbEQmBnM
         Gj9V1+GKh6fqWmZOocS5ItJCszffLsnEzkRABZosg5tfaH972t7tyZ6JZPk/IIk3K9PK
         9cXg==
X-Gm-Message-State: AOAM531D27z/V58Q0lX/1HSHCao6RF7ScfuYjYg6EwiVY9j3iu27kd5q
        9KrROIekxasnTP49WAuHbm/DRlLmdEFCZQ==
X-Google-Smtp-Source: ABdhPJzL4TVE2ZmLdK+X8Ime38AucFBJP/ru8QjY494q9pZhTWeJLxmhEama436Fg3gRphnMt2sahg==
X-Received: by 2002:a63:e80e:: with SMTP id s14mr63928961pgh.32.1594642519579;
        Mon, 13 Jul 2020 05:15:19 -0700 (PDT)
Received: from blackclown ([103.88.82.220])
        by smtp.gmail.com with ESMTPSA id o8sm13164541pgb.23.2020.07.13.05.15.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 13 Jul 2020 05:15:18 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:45:05 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] staging: qlge: qlge.h: Function definition arguments
 should have names.
Message-ID: <2d788cffeec2dad9ce9562c15a69d8b63ed0b21f.1594642213.git.usuraj35@gmail.com>
References: <cover.1594642213.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <cover.1594642213.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Issue found with checkpatch.pl

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 drivers/staging/qlge/qlge.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 05e4f47442a3..48bc494028ce 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2057,8 +2057,8 @@ enum {
 };
=20
 struct nic_operations {
-	int (*get_flash)(struct ql_adapter *);
-	int (*port_initialize)(struct ql_adapter *);
+	int (*get_flash)(struct ql_adapter *qdev);
+	int (*port_initialize)(struct ql_adapter *qdev);
 };
=20
 /*
@@ -2275,7 +2275,7 @@ int ql_mb_set_port_cfg(struct ql_adapter *qdev);
 int ql_wait_fifo_empty(struct ql_adapter *qdev);
 void ql_get_dump(struct ql_adapter *qdev, void *buff);
 netdev_tx_t ql_lb_send(struct sk_buff *skb, struct net_device *ndev);
-void ql_check_lb_frame(struct ql_adapter *, struct sk_buff *);
+void ql_check_lb_frame(struct ql_adapter *qdev, struct sk_buff *skb);
 int ql_own_firmware(struct ql_adapter *qdev);
 int ql_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget);
=20
--=20
2.17.1


--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8MUEgACgkQ+gRsbIfe
746+8BAAp6RmWWIkmwMpIRcvlLjr/DDRlK7chsKnQhbgSW13TWUOkT7MAuc1zjOU
xH0kMQLP/FQ+OZlssWXZ4oINTPXyp2U/7hOtD01AlbuCooDKRo47ryVKclDX1jRm
ygDm7vYxrPI26ru7lbiiIGl5/1C8cQoKxNfb7XlhBQz+cTNWa00wmouVI3//Jko0
qLHPVpHxL9zpUGcfVg1Mt+9Q7ashXxl28YH1ljJ4CjSgSWstl/CGSHntzxyQt8Tl
A58Y/LUpY3q7D26BpYjsK7f0NrZh5PHh6+X14WO4zjYlRCqL0SmPbnVeaEYiwIRM
wBSXVfIe69GYHbEeZTgZs0Te3240wagcozdlTqw/PEx6ZVhMl8sG14QJawRUEsGX
DZ6rSVfcC6zjISq4Hkp8FYaiKch1JfbmOu6GOWhybZyZlFSpH3U205d1pNvrqAAD
xvstGq9X0pzPzaUrNZ8F/RmuXN7ps6SvZC1XqSK04onmbABVPcwenqbLXZ7oH6YB
v2nYPta5e0NzgLxM734BA2Dp0hFDhS3b2nL64N8S0slR0CRf/I9qIxt7FfYJF5C+
MSERluUhWkknI2uhqpUrX0HuL1DSJBa16LXLqceWa+EQuaJ1XltZ6xjRdqR46mz3
bWK0PbNe3eZnSxZo81asB3A6ZP4ifGvcs8IUOUgaMKdMVrInHEk=
=kHsR
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--

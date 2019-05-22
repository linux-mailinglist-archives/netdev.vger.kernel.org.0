Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC2725BD0
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 03:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbfEVB51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 21:57:27 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35538 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEVB50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 21:57:26 -0400
Received: by mail-qt1-f194.google.com with SMTP id a39so559887qtk.2
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 18:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rgMk0/cmHCA+JVdog+AOe34V0MLrhuLGcNb8/ei0dEY=;
        b=B1n3+tGPYKkUBb9vypC6yjb/Nq+8Bg6DYyxRwSF0pjsUR/4po7eHN+BvMLdoajhsHu
         ciodQMp8Chq07/Z4m9kmlEKOj+nZkJQsebKviWtQgzWGy6xD4oFiFU4vbyTu+7CTxfGA
         W2q7NsTJRSbuQ1Rjwu/Y+wNaHf29pdVz00hmRCEvbfRNRjwQFbP4lABMkOkIJjRDRqNf
         fKdAOMhzxhp/lsm1NTaOz9HoJzvypnnab6NtUbNoNF6mI5OB/Y17RN3W8mRIK/6DeKeP
         KVNS2A/AqGIfrBc9NVZt/MJLEXGbvdnx2yE35K1opl3SXShTxz5vC9OxLrR/SaYDYRjd
         Xc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rgMk0/cmHCA+JVdog+AOe34V0MLrhuLGcNb8/ei0dEY=;
        b=MqVfpPTCEoknlYrg6k1ZuMkedRrelzwNi5ii/4v7nrIRJmCc2qRu0EbnPbYWVaPA1l
         1YZtpHp4QmhWdXr9GNz196tuegJBgkEa6q0+qoZ8pQekq/puqdFzow19jr7rycLH6ZOo
         VkgTy219cPnvG2GWSffZWqx36woBwuuke/wgtSQqUv33ZM03EpXIDbST/LWRCo6hPTzs
         /aF/bBjJosQWfuNJ0f3cjY5RxOgEvq+B3LQXwT1Ql7730Gjjxn5CK0dA//WrXlRgqjVK
         9eECGpvtC87SdqEaBJxj8QHLTh7cEhIZn6iOCVtBOg7CXLi2eidomQ+Bep8X7aMRjGKZ
         uQCQ==
X-Gm-Message-State: APjAAAU5MDZxtOsWzthf18hN0Ud88/o0m2grLGMuO4RtQSwsjiWpPC+l
        pGEptVbIOcAjdpxHU73A0MHXiKyLu4Y=
X-Google-Smtp-Source: APXvYqzqlATJ+1th+z0X7/+hkfYKdNNHyg0piZtjHbfHQ2F+o3hp93hSZWV3EvsWD9Uw0ynLqkQb4g==
X-Received: by 2002:ac8:2c6a:: with SMTP id e39mr55460113qta.179.1558490245715;
        Tue, 21 May 2019 18:57:25 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l16sm9614901qtj.60.2019.05.21.18.57.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 18:57:24 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        john.fastabend@gmail.com, vakul.garg@nxp.com, borisp@mellanox.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net v2 0/3] Documentation: tls: add offload documentation
Date:   Tue, 21 May 2019 18:57:11 -0700
Message-Id: <20190522015714.4077-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set adds documentation for TLS offload. It starts
by making the networking documentation a little easier
to navigate by hiding driver docs a little deeper.
It then RSTifys the existing Kernel TLS documentation.
Last but not least TLS offload documentation is added.
This should help vendors navigate the TLS offload, and
help ensure different implementations stay aligned from
user perspective.

v2:
 - address Alexei's and Boris'es commands on patch 3.

Jakub Kicinski (3):
  Documentation: net: move device drivers docs to a submenu
  Documentation: tls: RSTify the ktls documentation
  Documentation: add TLS offload documentation

 .../networking/device_drivers/index.rst       |  30 ++
 Documentation/networking/index.rst            |  16 +-
 .../networking/tls-offload-layers.svg         |   1 +
 .../networking/tls-offload-reorder-bad.svg    |   1 +
 .../networking/tls-offload-reorder-good.svg   |   1 +
 Documentation/networking/tls-offload.rst      | 482 ++++++++++++++++++
 Documentation/networking/{tls.txt => tls.rst} |  44 +-
 7 files changed, 549 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/index.rst
 create mode 100644 Documentation/networking/tls-offload-layers.svg
 create mode 100644 Documentation/networking/tls-offload-reorder-bad.svg
 create mode 100644 Documentation/networking/tls-offload-reorder-good.svg
 create mode 100644 Documentation/networking/tls-offload.rst
 rename Documentation/networking/{tls.txt => tls.rst} (88%)

-- 
2.21.0


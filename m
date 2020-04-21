Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBDE1B2144
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgDUIRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgDUIRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:17:05 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9FBC061A0F;
        Tue, 21 Apr 2020 01:17:03 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id w145so10388715lff.3;
        Tue, 21 Apr 2020 01:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qT6ZuW6H/bnC0x2akJVYOmPBEwGD1w226p2Ed4JIQpY=;
        b=AF2Bq+4RAAP4WwoRGv/PR1dn+BAuzSTFEF6LzSDAGRUrCi3ltVZYsG1uiu7zd/hJXC
         GsgA7LO5qwLX3p3K+o1oVh+icpp17xlDZjTpJNn3u/YOKFEAFXpMg5IjgV0BnXNvgyuE
         wtj1Mp+yUHY9D1XoEz71AYzt0sBK359lNMjKuMovVGgH+w1BloTUppaPZh0hxXAzfpHQ
         vDIogZb9urCK2/wI6kiF2nmG3l/IcVa440rYNFUfmkXaMjc7nH8ZAEQIev3mbiwFuaiZ
         RJ7dvVMNG4+7IIxBxjEM3M93bIbSyRngBwD9oGj8uLX0Ps8wliLXhwbcUAjJhO41rtmn
         Yy1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qT6ZuW6H/bnC0x2akJVYOmPBEwGD1w226p2Ed4JIQpY=;
        b=PO07ZlIlCxzGNyFeazt4CRPQWl3bxY52EyCSvBFMDJFBiNNz2nfn3y1zv6yfmc6XNr
         YSfz1bQA4YlWOeLT24ePpkqoXd9AXIKS5tP9KtmRpISoglvbIjuSbLkupte4VcLIchJS
         tBDDk94hLfJR+KhkiJaiCgpotYk4qV3BIBb592IFh6KXl7/IaAhuL8ykcWWUos+KtyqK
         EauNnawouKtg+Jq8PJlMsx9yH3i93qbenAXHQwLf3CN5BVN6005itYcqL2GkaVgSIh0D
         nFKFTnqT20p2as2s9TDxbSqP5n2NJPfoNr4UDdqS/D8qHXUpyT8mIqP49UE42LSyrmoO
         xJcA==
X-Gm-Message-State: AGi0Pubh6vjM9vUYMd538vZ4Zi8KB16uFCKqX90I24TCQQa/63q/gYkA
        Jk2Dwoj8VZWMuq+BgG1zGUA=
X-Google-Smtp-Source: APiQypKq4AOwfvIZ5pwMIp42g2Uj+koYCzjJQvLizQWfRXcE/GewHXtfQVut7+0QWFlf1wUK+jKTcw==
X-Received: by 2002:ac2:41d9:: with SMTP id d25mr13158140lfi.204.1587457022307;
        Tue, 21 Apr 2020 01:17:02 -0700 (PDT)
Received: from localhost.localdomain ([87.200.95.144])
        by smtp.gmail.com with ESMTPSA id j13sm1472756lfb.19.2020.04.21.01.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 01:17:01 -0700 (PDT)
From:   Christian Hewitt <christianshewitt@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        chewitt <christianshewitt@gmail.com>
Subject: [PATCH 0/3] Bluetooth: hci_qca: add support for QCA9377
Date:   Tue, 21 Apr 2020 08:16:53 +0000
Message-Id: <20200421081656.9067-1-christianshewitt@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: chewitt <christianshewitt@gmail.com>

This series adds a new compatible for the QCA9377 BT device that is found
in many Android TV box devices, makes minor changes to allow max-speed
values for the device to be read from device-tree, and updates bindings
to reflect those changes.

Christian Hewitt (3):
  dt-bindings: net: bluetooth: Add device tree bindings for QCA9377
  Bluetooth: hci_qca: add compatible for QCA9377
  Bluetooth: hci_qca: allow max-speed to be set for QCA9377 devices

 .../bindings/net/qualcomm-bluetooth.txt         |  5 +++++
 drivers/bluetooth/hci_qca.c                     | 17 ++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

-- 
2.17.1


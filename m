Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178D61757CD
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 10:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgCBJ7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 04:59:10 -0500
Received: from mail-pl1-f169.google.com ([209.85.214.169]:36615 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgCBJ7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 04:59:10 -0500
Received: by mail-pl1-f169.google.com with SMTP id g12so1982458plo.3
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 01:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pkTC6Wn/1DxUylg3ynLWNOWrRFoLHBTbKbPNtYhTNgM=;
        b=gbozQKZGmtrtU8/WGLxeLOVkOLvBIlSZR2YmA0zog+UA0vPvxLb2RZ911v5WvaV3KC
         4YIX6zTmS0b98il7Z6zf1q8L3oLtTXpx2IrILOPO1q9A1YC4bjLKt/E9ROG+w+rR40ky
         YuPjgAMoxCyjydi3lI2so8RpEby7xdUclL/L5R2hLamddmg2al+bLE92pVE6cWOQC5X7
         NA25VvhLq7QPMlYHckAXPMDoV9T/abrHi+mY3rrh2JXPOuSGkYZWO2VNjEtTRgEgQP2g
         CS3N9kWR89za1/e4zX0tzNzHN4ND4xErznM5IW0q6ZzDBldXHXrRdx0YqEYr9RiQliJD
         uM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pkTC6Wn/1DxUylg3ynLWNOWrRFoLHBTbKbPNtYhTNgM=;
        b=jx8y22Dp+pZR2sKlIEEIMrVGb31dZyLxoCsN1YdsquCMVD80urhGpKO2tfMAg1AS/w
         lehnk/9k3aLSMTG6fLhZsk5gikPyBTYWQHLD30e7clVthKb4+Xoei7GgCtQ03d5nyTIe
         BsujDF3csZiGaoD49vo5fJ48/rEdsyJOJmMoJTN7AyCMtjZFWWyiSXjcGJEFn7hmO7XZ
         pBom1xjBoVIjmtg5m05z+uLQbc/Xydmda8mrdJIgMHQgRUhnKm4ZhpXHQK5eFdqNrdTY
         QioIElFhd6nl7m9UDAepANdR5wmXIxEoH6n9gafDn6p2Pob8D0ujtm+yZjw6r18Wks6G
         GG1g==
X-Gm-Message-State: ANhLgQ1mmDGogAk18psEMm+3kmWka1p4KShgfSRXVzsh4CuHatIEcc4A
        MPh/IHjth0bVGd/a1gcwpA8NjXSe8B4=
X-Google-Smtp-Source: ADFU+vuhI+xILaAAAIBNepBiu6P55S+JmmL+dDWtFDDi1Kjwd5KPBDI7ee4Ta3HqAPIzmf0owhDoqw==
X-Received: by 2002:a17:90b:490e:: with SMTP id kr14mr4012867pjb.21.1583143149110;
        Mon, 02 Mar 2020 01:59:09 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id z13sm20564307pge.29.2020.03.02.01.59.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 02 Mar 2020 01:59:08 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 0/3] net: thunderx: Miscellaneous changes
Date:   Mon,  2 Mar 2020 15:28:59 +0530
Message-Id: <1583143142-7958-1-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patchset has changes wrt driver performance optimization,
load time optimization. And a change to PCI device regiatration
table for timestamp device.

Geetha sowjanya (1):
  net: thunderx: Reduce mbox wait response time.

Prakash Brahmajyosyula (1):
  net: cavium: Register driver with PCI subsys IDs

Sunil Goutham (1):
  net: thunderx: Adjust CQE_RX drop levels for better performance

 drivers/net/ethernet/cavium/common/cavium_ptp.c    | 10 +++++++++-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |  9 ++++-----
 drivers/net/ethernet/cavium/thunder/nicvf_queues.h |  4 ++--
 3 files changed, 15 insertions(+), 8 deletions(-)

-- 
2.7.4


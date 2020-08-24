Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EB524F32C
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 09:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgHXHht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 03:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgHXHhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 03:37:48 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FE7C061573
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:37:48 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id p25so6605591qkp.2
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 00:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WSlulmSSlwj5nGIJfCEx8kLyn4FEhJjaElPGH8H1ixc=;
        b=qytO71aIRoyTyktFMpzjl3JutCiKeve6+YOYXOffJNSN6kaD2LYCRyUHC1YG/PO1Hl
         ED0WkJW5HmDOBQoyGslqFRepdfrGuuSdnY9+jl+eH53cAE7fdfCNzRrDZxIdUYi71TGc
         t4vgAdlJphzvuIulNcqjNu+RWbPmB6tfACeS3gUFbIcjQmaUzYu1qXGa7G/lE9O2pVaP
         HRt02QQy5ZsY+iKkLGyUOJ5H8rqt2uFpNK2/nU7hMlMCz6uzWQg6GmkvCPvxBVcgYBcM
         rs6cuKPyW4azeO0D5a2masPL8c6qe26Ek4NKd3EZ/1qlDI4QsGe/vnqipQWcvPhMChxd
         WCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WSlulmSSlwj5nGIJfCEx8kLyn4FEhJjaElPGH8H1ixc=;
        b=QUK8Xy33CArR+LOyGkCk/+622h7HKZbPq1W5+AFFIjX8OXl5fHryLzfXucZznGfs2a
         cfHkaj5XOf/rBB0nlwXPJHL08lbyNWzFqUnQ/UK0b5dREd1H1q9YUnEz2ompLUDBKIci
         bOsNjQAJFqO67WJadYevaCblotlIbXHajWqeetGdZax8k+8MmjfyVDHzVV31uVjZmOrE
         ZhROee0JQLy1gCCCwJdHa2sTTvo67BLLljd6Mqx9lG9iqxKdzwn5SOlD5zPXtzq8qHA9
         WUIq0fkuagQcu6BzINJRWBgFMaOJ8hPHIXttlFJBookBKveCs6tLW+p5hn/YLv4YzJG2
         sqOg==
X-Gm-Message-State: AOAM530bYVud6WBsdoxPSG4ypGkTfF9bNf7PC51Au8/F+ancWhGgTTZN
        9gDY/+8PsQ0kUt5M/rcSnbw=
X-Google-Smtp-Source: ABdhPJyN0zSbjMxmBYQQlUpWVOWMZnZCRcNFcRGHqggWeQnSuUZxUCeFJfW68hxGare3CcEcLyw53w==
X-Received: by 2002:a37:a493:: with SMTP id n141mr3490986qke.351.1598254665987;
        Mon, 24 Aug 2020 00:37:45 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id y9sm9092322qka.0.2020.08.24.00.37.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 00:37:45 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     davem@davemloft.net, pshelar@ovn.org, xiyou.wangcong@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 0/3] net: openvswitch: improve codes
Date:   Mon, 24 Aug 2020 15:35:59 +0800
Message-Id: <20200824073602.70812-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This series patches are not bug fix, just improve codes.

Tonghao Zhang (3):
  net: openvswitch: improve coding style
  net: openvswitch: refactor flow free function
  net: openvswitch: remove unused keep_flows

 net/openvswitch/actions.c    |  5 +--
 net/openvswitch/datapath.c   | 35 ++++++++++---------
 net/openvswitch/flow_table.c | 65 +++++++++++++++++-------------------
 net/openvswitch/flow_table.h |  1 -
 net/openvswitch/vport.c      |  7 ++--
 5 files changed, 57 insertions(+), 56 deletions(-)

-- 
2.23.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246BE60E202
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiJZNWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233280AbiJZNWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:22:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AA713D7F
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:22:24 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1666790543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZDdqAL45+BmZHlGCi6z8VE8VIOFWLcGCMbwuUSNJvLc=;
        b=JBoGYwTXp9qo/4Z/r0vR9dxubbkbo8uM99oQ+D8eTa+S/jo6YtvxJRdsxkD6OzexgX6W7X
        Y/QC/E8iF3yauoHxf9k8ctA2OZdsKHDPOSHRMkm0SbQaYq0nXAqIn0O3lUKzVhnS/1182R
        0kWVVXrWxYVcORxx7PXfXeXokzA1aZv4Kykkkv+7O1bMf/yWGTEUzR/X26kKtpaN5xj10B
        8GTd/hdoPb2aleKXHTWqsJhpawoNFmysEw9KxHvyPpjLSZIq6KFF7mnAU161hZCtqzDVpX
        JDYG0oSmgqCmyV8vAJcZROuRP1kRVobz+ql4DjtojRalnSb0pUNhg8vJRTMVWg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1666790543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZDdqAL45+BmZHlGCi6z8VE8VIOFWLcGCMbwuUSNJvLc=;
        b=KJPHh96+XWMLZP4vSYP/D8eLswCC8qLcTTCwe0Tn+ovyAiJukQlRSlpT7RtIjEHudSh/qm
        wptlpBKk8SQCXHCw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/2] net: Remove the obsolte u64_stats_fetch_*_irq()
Date:   Wed, 26 Oct 2022 15:22:13 +0200
Message-Id: <20221026132215.696950-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the removal of u64_stats_fetch_*_irq() users in networking. The
prerequisites are part of v6.1-rc1. I made two patches, one for net/ and
the other for drivers/net. Hope that is okay.
The spi and bpf bits are not part of the series and have been routed
directly.

Sebastian



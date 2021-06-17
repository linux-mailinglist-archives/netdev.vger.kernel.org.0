Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6183AAA37
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 06:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhFQEk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 00:40:57 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:32574 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbhFQEkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 00:40:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623904729; x=1655440729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VB6EeDBC6iR6uE3/NSbgxvUWFdvoOYrWaYJmsRrSBdQ=;
  b=DHbMoQEBg5CKorCuoy7FX8VmyuLawPuSINoIEjZ2Ez/9lhxHoXelUHHy
   eEU6t9wxNwuodj+hHPbHpyJFlYhITLv6cdRD7149zOT4QEXccBsVybiyW
   KsVVllCEK2qbzEm689JP/fZD3vE+CMXkb9X16DbkAHpuKaowqFGOgPE3r
   0=;
X-IronPort-AV: E=Sophos;i="5.83,278,1616457600"; 
   d="scan'208";a="7119446"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 17 Jun 2021 04:38:49 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 8A549A2A17;
        Thu, 17 Jun 2021 04:38:48 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 17 Jun 2021 04:38:47 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 17 Jun 2021 04:38:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <andrii@kernel.org>
CC:     <ast@fb.com>, <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <kuniyu@amazon.co.jp>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix selftests build with old system-wide headers
Date:   Thu, 17 Jun 2021 13:38:27 +0900
Message-ID: <20210617043827.9041-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210617041446.425283-1-andrii@kernel.org>
References: <20210617041446.425283-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.153]
X-ClientProxiedBy: EX13D44UWC003.ant.amazon.com (10.43.162.138) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Andrii Nakryiko <andrii@kernel.org>
Date:   Wed, 16 Jun 2021 21:14:46 -0700
> migrate_reuseport.c selftest relies on having TCP_FASTOPEN_CONNECT defined in
> system-wide netinet/tcp.h. Selftests can use up-to-date uapi/linux/tcp.h, but
> that one doesn't have SOL_TCP. So instead of switching everything to uapi
> header, add #define for TCP_FASTOPEN_CONNECT to fix the build.

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Thank you!

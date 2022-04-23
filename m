Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79F350CBB2
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 17:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiDWP0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 11:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbiDWP0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 11:26:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DED33E93
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 08:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5ACAB80CC7
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 15:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7022C385A0;
        Sat, 23 Apr 2022 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650727386;
        bh=l9uoqw2nMkn5fbl4XoR38nj7E1m46WQUDvDzfWspgWE=;
        h=From:To:Cc:Subject:Date:From;
        b=RgROPjo9F6kxMvfWBo7Z5aiq+YbZUXUE3Av2PKyP1yqGeIcTWBloifHohMuV0PKUB
         eusFcPD58blMvRV71H34v87qSk5hee+Tfp6bn34sMe1B/j4w8uDu2dAOd0nKo3wUoE
         a+lmG/RG/EwEcZvyqT4YrJZaLIGRdpB0o45Hf8VcR6y5B9rM4gGjz6lx3sA9ReMq00
         +TSDaUe99Tq3GC7+PHy+nLsTukkYJt2GdU7NaV+Dg4Cx5nKFy9BiAFQTk45e8T8zYb
         +wvqiHI9ElIf2O/pF3zKhQiyZsTJxVTf3vzNxkfCtI62dSoLmR4oErjr8M0e1eoDIo
         HbHNGmZUoh/rA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, toke@redhat.com, haliu@redhat.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 0/3] Address more libbpf deprecations
Date:   Sat, 23 Apr 2022 09:22:57 -0600
Message-Id: <20220423152300.16201-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another round of changes to handle libbpf deprecations. Compiles are
clean as of libbpf commit 533c7666eb72 ("Fix downloads formats").

David Ahern (3):
  libbpf: Use bpf_object__load instead of bpf_object__load_xattr
  libbpf: Remove use of bpf_program__set_priv and bpf_program__priv
  libbpf: Remove use of bpf_map_is_offload_neutral

 lib/bpf_libbpf.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

-- 
2.24.3 (Apple Git-128)


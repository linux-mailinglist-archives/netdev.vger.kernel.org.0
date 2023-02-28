Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA306A5EF4
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 19:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjB1Sqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 13:46:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjB1Squ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 13:46:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C8912BEF;
        Tue, 28 Feb 2023 10:46:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C0E1B80E69;
        Tue, 28 Feb 2023 18:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7E3C433D2;
        Tue, 28 Feb 2023 18:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677610007;
        bh=ceXcKmSlC7n2+j9wLpzz3kcr7DaDgLacJwFFfZL2REs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HzDDQTI51jNeVxSX1bnLvUH0Uom/O/LLOIK80+wvYQ36OQHyXLWF5OvYX4/p5sTyP
         1bsFYM9XSpbZ5fHz5+5hYtqSz5HMI2cTI995smr4zo3Hbm459GXCM3zFAgVMXBZ3jg
         szYAHkgbPP2Y1PsVdsStyudN4DmSnueD6H8P7iWQ=
Date:   Tue, 28 Feb 2023 19:46:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Edward Liaw <edliaw@google.com>
Cc:     stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, bpf@vger.kernel.org,
        kernel-team@android.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14 v3 0/4] BPF fixes for CVE-2021-3444 and CVE-2021-3600
Message-ID: <Y/5MFNdlHVW6zdAA@kroah.com>
References: <20230224034020.2080637-1-edliaw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224034020.2080637-1-edliaw@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 03:40:15AM +0000, Edward Liaw wrote:
> Thadeu Lima de Souza Cascardo originally sent this patch but it failed to
> merge because of a compilation error:
> 
> https://lore.kernel.org/bpf/20210830183211.339054-1-cascardo@canonical.com/T/
> 
> v3:
> Added upstream commit hash from 4.19.y and added detail to changelog.
> 
> v2:
> Removed redefinition of tmp to fix compilation with CONFIG_BPF_JIT_ALWAYS_ON
> enabled.
> 
> -Edward

Now queued up, thanks.

greg k-h

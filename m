Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080AA4CB00A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 21:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243567AbiCBUj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 15:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239929AbiCBUjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 15:39:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD05C46654;
        Wed,  2 Mar 2022 12:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Lnsq5ECKK2HtO41PTE0g9xeHGI0dZEMSI8nTo7bFmeg=; b=dYjKhLD9ma//TONGDNJRWUs+md
        3SDdsoIxiJ5l4UWOYksN3g55iM6o1eOhNX+oRBHgSrSQYFcmXHf0PsVB0zZ1DypQcjXUX0ZdqtkCo
        96rHs2cdKKCZKY4K1vzWCDgX1EluXJdyez9dyUJSz0rU0MXF3lyYH6ElnfdBRNs3cOqJLTGDVjpFN
        X8s4pIh2pJoqp8DO59gXBx8bew0U9zJil/e6NSdzNbXamGycdfEo/O2oD6IpdsCZcxsFjsfMnoPX1
        FQPSH9IcZGjpoGoWGdIFIimr0L4NNUGAby5p2o+EguhUGwjalFbiwBV/5NMn4VBNLpVFzaEsmAiD4
        JQkhx/6Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPVkT-0046vs-HN; Wed, 02 Mar 2022 20:39:01 +0000
Date:   Wed, 2 Mar 2022 12:39:01 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Yan Zhu <zhuyan34@huawei.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucheng32@huawei.com, netdev@vger.kernel.org,
        nixiaoming@huawei.com, songliubraving@fb.com,
        xiechengliang1@huawei.com, yhs@fb.com, yzaikin@google.com,
        zengweilin@huawei.com
Subject: Re: [PATCH v3 sysctl-next] bpf: move bpf sysctls from
 kernel/sysctl.c to bpf module
Message-ID: <Yh/V5QN1OhN9IKsI@bombadil.infradead.org>
References: <Yh1dtBTeRtjD0eGp@bombadil.infradead.org>
 <20220302020412.128772-1-zhuyan34@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302020412.128772-1-zhuyan34@huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 10:04:12AM +0800, Yan Zhu wrote:
> We're moving sysctls out of kernel/sysctl.c as its a mess. We
> already moved all filesystem sysctls out. And with time the goal is
> to move all sysctls out to their own susbsystem/actual user.
> 
> kernel/sysctl.c has grown to an insane mess and its easy to run
> into conflicts with it. The effort to move them out is part of this.
> 
> Signed-off-by: Yan Zhu <zhuyan34@huawei.com>

Daniel, let me know if this makes more sense now, and if so I can
offer take it through sysctl-next to avoid conflicts more sysctl knobs
get moved out from kernel/sysctl.c.

  Luis

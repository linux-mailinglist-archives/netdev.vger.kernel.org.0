Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B1D6D9F55
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 19:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239764AbjDFRz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 13:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239649AbjDFRzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 13:55:25 -0400
Received: from out-6.mta1.migadu.com (out-6.mta1.migadu.com [IPv6:2001:41d0:203:375::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2ECE63
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 10:55:23 -0700 (PDT)
Message-ID: <d290fadb-0a35-8824-0404-044262e09ee0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680803721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S2wBh/jLTy+deEtWdhlk9cI2iweUhhuyvGEcfl1nGzg=;
        b=dRnjSyiZuFIWGsXNP05ZJ4GiVzbVo3vCzGqegmnzyzt/s6KKBYKgxKD8oOptDcwStw2kar
        i4+Fm0FJOMP/NpZaNv1OLQYkoJK3eHcqgfv7iGFo+1pEQdyxf8jI6yeSLO1O7S1GLIdBV0
        8XTsvZMI4wQusSbLdj5TsluctnSKwk4=
Date:   Thu, 6 Apr 2023 10:55:16 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf] selftests/bpf: fix xdp_redirect xdp-features selftest
 for veth driver
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, andrii@kernel.org, bpf@vger.kernel.org
References: <bc35455cfbb1d4f7f52536955ded81ad47d8dc54.1680777371.git.lorenzo@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <bc35455cfbb1d4f7f52536955ded81ad47d8dc54.1680777371.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/23 3:40 AM, Lorenzo Bianconi wrote:
> xdp-features supported by veth driver are no more static, but they
> depends on veth configuration (e.g. if GRO is enabled/disabled or
> TX/RX queue configuration). Take it into account in xdp_redirect
> xdp-features selftest for veth driver.
> 
> Fixes: fccca038f300 ("veth: take into account device reconfiguration for xdp_features flag")

Applied to the bpf tree. Thanks for the quick fix!


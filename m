Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2486E6D1C
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbjDRTuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbjDRTuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:50:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6BD9EDB;
        Tue, 18 Apr 2023 12:50:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1porKz-0006R5-2m; Tue, 18 Apr 2023 21:50:01 +0200
Date:   Tue, 18 Apr 2023 21:50:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next v3 5/6] tools: bpftool: print netfilter link info
Message-ID: <20230418195001.GB21058@breakpoint.cc>
References: <20230418131038.18054-1-fw@strlen.de>
 <20230418131038.18054-6-fw@strlen.de>
 <b325e432-7652-96d3-055a-0107a88ea1fa@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b325e432-7652-96d3-055a-0107a88ea1fa@isovalent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Monnet <quentin@isovalent.com> wrote:
> > +			if (nf_link_count > (INT_MAX / sizeof(info))) {
> > +				fprintf(stderr, "link count %d\n", nf_link_count);
> 
> The only nit I have is that we could use p_err() here, and have a more
> descriptive message (letting user know that we've reached a limit).

Drats, I'll replace this and will retain your RvB tag in v4, thanks.

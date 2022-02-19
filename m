Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB15E4BC55E
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 05:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbiBSEif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 23:38:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiBSEid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 23:38:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3904A928
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 20:38:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAB7C60A50
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 04:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6223C004E1;
        Sat, 19 Feb 2022 04:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645245495;
        bh=wm9r3biuyigid6BVXSQA8aSTCwxqcJXDDZ6l9hHYPOs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DzgUYxKiRME04n6gG/y/+pTFzH+JtZ1ZHbt03f6yHFCsfr4cJ+qM+sB6qMH8LhNZ/
         aQNMByc0OPzK9lfHgjSG/QA9klbOkrH0azWG6jDlZmH8mW/pysqeo5vp2QO+VcyB/x
         PMr04On5I2u8CNiY0F3gsq7awL1l2BG1n6xhrz9n5Ak+avaVSF/H6d8Z4WuWH9aNh9
         wKlPxFb0ZKw8UoTiQoRumeIK4Qn40zo8ZSK62D2MZq8x0oWgCINFpx2s1/kwWQYbxs
         Ejt657kRRhZzbT+Vzqeuhj9iZt/Yji0OvUJKRQQOxNGLQSzxe3EQJztLHedGc4M/l2
         ShDEcn3Wc3m7Q==
Date:   Fri, 18 Feb 2022 20:38:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH net-next 1/4] ionic: catch transition back to RUNNING
 with fw_generation 0
Message-ID: <20220218203813.72d17001@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ad4ddff0-2fd8-f172-a674-0e88209efbf6@pensando.io>
References: <20220217220252.52293-1-snelson@pensando.io>
        <20220217220252.52293-2-snelson@pensando.io>
        <20220217201213.3e794f82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ad4ddff0-2fd8-f172-a674-0e88209efbf6@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 09:30:45 -0800 Shannon Nelson wrote:
> On 2/17/22 8:12 PM, Jakub Kicinski wrote:
> > This looks like a fix, and should go separately to net.
> > Is there a reason behind posting together? The other patches
> > don't even depend on this one.  
> 
> I posted it to net-next because the patch it is fixing is still in 
> net-next and not in net or stable yet.

Not sure how I missed that, sorry.

Applied now, thanks!

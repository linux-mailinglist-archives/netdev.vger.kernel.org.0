Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0209F4E38B9
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 07:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiCVGMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 02:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236986AbiCVGMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 02:12:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760CA31357
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 23:11:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29FC4B81BA1
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 06:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A69C340ED;
        Tue, 22 Mar 2022 06:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647929484;
        bh=S5EPAJVgBbC6qNhzAJ+GUw8JHZliTKGWfD4cfreyViY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kPp9ye/v8x5dfka3uass3WSRK279zdsXR3ta3knGlRN/qxY4f2qpPywYbh5Tq5R5R
         sk+ZOIKQfh5yyMjzjVKzKPDah+F5S9FBfgh5vWQk0YfhAN9icQI7k4qosZLu1lvvc+
         0J1S91kZ/dBiQ4mjPcWFHg0yyRKEUUi4DQzXl2zxa2D8/bfalIgo4KIPdb6YtbudzM
         6YcEpUbIiGYYv8rA8yyhfGm46q8KzsK/MD3qtiiHRqPKWbWtWcJIY0QZBOIzkEetB+
         7lPt/JmX5zZPZ4YuMkK80WiOxv+iZUrQjHxkfr0D1DpZdtuFHMPb7/5L4ni1z/arka
         ZRhcrVsGouCcg==
Date:   Mon, 21 Mar 2022 23:11:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next v2 00/11] bnxt: Support XDP multi buffer
Message-ID: <20220321231122.675b7ca7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1647806284-8529-1-git-send-email-michael.chan@broadcom.com>
References: <1647806284-8529-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Mar 2022 15:57:53 -0400 Michael Chan wrote:
> This series adds XDP multi buffer support, allowing MTU to go beyond
> the page size limit.
> 
> v2: Fix uninitialized variable warnings in patch 1 and 10.
> 
> Dave, please don't apply these patches too quickly so that others can
> review them first.  Thanks.

Please widen the CC list on v3. People who had been involved in XDP
mbuf discussions would be good to CC.

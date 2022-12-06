Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C16644C1F
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLFS7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiLFS7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:59:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22B337225
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:58:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 552A1B81A26
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 18:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A4DC433C1
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 18:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670353137;
        bh=tQZeDhE3a01ff6COF8vO7k2pcJVaCnq0/rY/Vgiysxw=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=twaYpPdBf9XgZGl0pd3f1yHfzGXWZ4yle6YMqJ3a2JmV4ZZcHL/nM307jCd5H+cOh
         sfOrDIvOkodKWIkbIAk74V25j5YWECl1RfHW0KsnlOlfs9B2fcD/uc/5blljIpkNNe
         AJyIo18UfUmHCHewV+b/Fu2W0kMM8fRoamixRMXg+U9xfGYykR/+GSvR9iM6pXud8p
         X2AB9S0tzoYvpPaIcoBwm+8/P4w8vtHUR3ymARPlLCzQ7UKBhS3RP60dWfLXdnZddq
         MWISGu3kDEvWvbOHg52oJYbcFJKPad0cjMxikWgOLJmxav/3BNc/i2YHL8IF8YgVHA
         WZ/uz4ua6K1kw==
Date:   Tue, 6 Dec 2022 10:58:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Dec 2022 call minutes
Message-ID: <20221206105856.17129932@kernel.org>
In-Reply-To: <20221206105832.7ade246d@kernel.org>
References: <20221206105832.7ade246d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Dec 2022 10:58:32 -0800 Jakub Kicinski wrote:
> Hi,
> 
> I've added the meeting notes to this doc:
> 
> https://docs.google.com/document/d/1iq7vuleJVyFPZnO-Ey-N7AumxUTgLdnnfR8nuLuNLxw/
> 
> And will just use this doc going forward.
> 
> 
> Thanks to Pavan for reviews last week, and nVidia's reviews which
> are already flowing!

Well, shit, I sent this to the wrong list. Let me send one more email
then...

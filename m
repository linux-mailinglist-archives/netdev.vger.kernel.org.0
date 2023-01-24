Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725E567A6B6
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 00:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjAXXLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 18:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjAXXLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 18:11:35 -0500
Received: from mail1.systemli.org (mail1.systemli.org [93.190.126.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E974B89B
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 15:11:34 -0800 (PST)
Message-ID: <c609fe45-08ea-0b87-eb1b-df171db14129@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1674601889;
        bh=cKX15GrqhFj7qMeujdNsTkcLUrXByIQEAGYDdsnsDoU=;
        h=Date:To:Cc:References:Subject:From:In-Reply-To:From;
        b=kYY+ByH6djI1Tz/k5ZAkHS2ieOnFE9+ri54nRa4TF+IjDzGb944pwFxeGfygJM/a2
         F7dXIh1oAaeLiXBiwKb6nRWIspdM3khkCvVy1VdlQfYwfPudy474nhBx+vUMtOWUtL
         yblermeWrDBnAikrWoI4L328bAeCh0NWotCYulwbCUVUTii3u61BfVLW5je4MJo/4J
         zY7A1rRP4zb9u5fLtPD2XXRqvaIubEFVVQX08oslneSH62l9aEv0aUcIEnCootBpbG
         QJ3tca3VeV9kxPB/XwRrwVVxcoMzAwKzsrELjmsaXh9nhWPXI5cs5llcUJYz2nSeY3
         /TmgCQm4ZwBGw==
Date:   Wed, 25 Jan 2023 00:11:27 +0100
MIME-Version: 1.0
To:     vincent@systemli.org
Cc:     netdev@vger.kernel.org
References: <0723288b-b465-25d4-5070-d8aa80828b11@systemli.org>
Subject: Re: ethtool: introducing "-D_POSIX_C_SOURCE=200809L" breaks
 compilation with OpenWrt
Content-Language: en-US
From:   Nick <nick@systemli.org>
In-Reply-To: <0723288b-b465-25d4-5070-d8aa80828b11@systemli.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any news on this?


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AB74C9302
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbiCAS05 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 1 Mar 2022 13:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236916AbiCAS05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 13:26:57 -0500
Received: from bergelmir.uberspace.de (bergelmir.uberspace.de [185.26.156.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A116516C
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:26:13 -0800 (PST)
Received: (qmail 24058 invoked by uid 989); 1 Mar 2022 18:26:11 -0000
Authentication-Results: bergelmir.uberspace.de;
        auth=pass (plain)
MIME-Version: 1.0
Date:   Tue, 01 Mar 2022 18:26:10 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.16.0
From:   daniel@braunwarth.dev
Message-ID: <d928314fccec204c36979e253b8fc4ae@braunwarth.dev>
Subject: Re: [PATCH iproute2-next 1/2] lib: add profinet and ethercat as
 link layer protocol names
To:     "Stephen Hemminger" <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
In-Reply-To: <20220228092133.59909985@hermes.local>
References: <20220228092133.59909985@hermes.local>
 <20220228134520.118589-1-daniel@braunwarth.dev>
 <20220228134520.118589-2-daniel@braunwarth.dev>
X-Rspamd-Bar: ---
X-Rspamd-Report: BAYES_HAM(-2.943364) MIME_GOOD(-0.1)
X-Rspamd-Score: -3.043364
Received: from unknown (HELO unkown) (::1)
        by bergelmir.uberspace.de (Haraka/2.8.28) with ESMTPSA; Tue, 01 Mar 2022 19:26:10 +0100
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

February 28, 2022 6:21 PM, "Stephen Hemminger" <stephen@networkplumber.org> wrote:
> This is legacy table. Original author did choose to use stanard
> file /etc/ethertypes. Not sure why??

I tried to extend /etc/ethertypes with the following line:
ETHERCAT        88A4    ethercat

I would expect the following command to successfully run:
tc filter add dev eno1 protocol ethercat matchall action drop

Unfortunately all I get is:
Error: argument "ethercat" is wrong: invalid protocol

With my patches applied, the command runs without any error.


I wasn't able to find any hint in the code, where /etc/ethertypes is supposed to be parsed. Could you give me a hint?


Thanks

Daniel

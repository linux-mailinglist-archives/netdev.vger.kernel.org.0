Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7505FBC3B
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 22:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiJKUjP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Oct 2022 16:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJKUjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 16:39:12 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355629DF80
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 13:39:11 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 11E3414112E;
        Tue, 11 Oct 2022 22:39:03 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id rVTmKtWqO04v; Tue, 11 Oct 2022 22:38:57 +0200 (CEST)
Received: from x61w.mirbsd.org (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 00632140E95;
        Tue, 11 Oct 2022 22:38:56 +0200 (CEST)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id A475A616C0; Tue, 11 Oct 2022 22:38:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 9E7D0616AF;
        Tue, 11 Oct 2022 22:38:55 +0200 (CEST)
Date:   Tue, 11 Oct 2022 22:38:55 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Dave Taht <dave.taht@gmail.com>
cc:     netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
In-Reply-To: <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de>
Message-ID: <65b3ad21-f13-315-40df-311b456e6c8@tarent.de>
References: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de> <CAA93jw5J5XzhKb_L0C5uw1e3yz_4ithUnWO6nAmeeAEn7jyYiQ@mail.gmail.com> <1a1214b6-fc29-1e11-ec21-682684188513@tarent.de> <CAA93jw6ReJPD=5oQ8mvcDCMNV8px8pB4UBjq=PDJvfE=kwxCRg@mail.gmail.com>
 <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Oct 2022, Thorsten Glaser wrote:

> And yes, it (commit dbb99579808dcf106264f28f3c8cf5ef2f2c05bf) still

Probably best run it through…

unifdef -DJANZ_REPORTING=0 janz/sch_janz.c >janz-reduced.c

… and read that instead.

bye,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************

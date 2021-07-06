Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D933BD8B0
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 16:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhGFOqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 10:46:08 -0400
Received: from mail.2ds.eu ([159.69.24.75]:47336 "EHLO mail.2ds.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232530AbhGFOqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 10:46:00 -0400
Received: by mail.2ds.eu (Postfix, from userid 119)
        id 0EE42C70D2; Tue,  6 Jul 2021 14:43:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on cloud-db-1
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from [192.168.1.168] (91-133-69-233.stat.cablelink.at [91.133.69.233])
        (Authenticated sender: admin@2ds.eu)
        by mail.2ds.eu (Postfix) with ESMTPSA id 973C5C7085;
        Tue,  6 Jul 2021 14:43:17 +0000 (UTC)
Message-ID: <fcc605013a1b156cbd8e5e1b50a0dc2ecb4a307e.camel@2ds.eu>
Subject: Re: Load on RTL8168g/8111g stalls network for multiple seconds
From:   Johannes =?ISO-8859-1?Q?Brandst=E4tter?= <jbrandst@2ds.eu>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
Date:   Tue, 06 Jul 2021 16:43:17 +0200
In-Reply-To: <YL61ojQeppA471Lw@lunn.ch>
References: <5b08afe02cb0baa7ae3e19fd0bc9d1cbe9ea89c9.camel@2ds.eu>
         <a4e4902d-5534-6c66-63f5-d88059604c78@gmail.com> <YL61ojQeppA471Lw@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks a lot for your quick responses, and sorry it took me so long to
get back to you. I tried all of your suggestions, but nothing really
changed anything about the stall happening.

The machine has a few services which my network relies on, so
interrupting normal operation is not desired. And as the current usb
adapter solution is working fine, there was no real incentive to change
anything yet.

I still want to try a few things, upgrade to the final 5.13, and set up
a better test network for promisc mode. If I gather anything useful
I'll
let you know.

Johannes


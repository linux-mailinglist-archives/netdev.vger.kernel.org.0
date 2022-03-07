Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D704D0870
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238687AbiCGUis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiCGUis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:38:48 -0500
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E380E2FFCE
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:37:51 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1646685469; bh=oNYRpAf+XzmxOw0CjclMkYXRPZAT8iNUwl5/9es1AT4=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=tpKjtkeFrHEQFQJYTKAjz1qrfxIUYRY82EL+QHy+Jyd/oBvt5sxhelRm/a7sOaSEU
         hFkNFMfVkxm44mqWnwrYAEpEnmHEcbPYOj6Mm8Z29jS1ul2LpmXa/LW7jnCzHDOB9d
         Y9qb5O4JVMHBDmqV+CS/ThmmBAliAlVmLrq8GhOsLRg4ATtHRdtQJJ8ObyYqbbKF09
         6FfM2JYW3y9GqxvAfQ3BTLwVzssQ8Hgb5QuVDj9ZrXCVm/T/r2rjLbFOWzRcaHV8u4
         GUhYz2EiFe04sEJpVUeLr1+UjUHbbAbIldX6DEagXDXE/B/uYqjjLajHwCGXfYRjmz
         1DkjZKgnMWMnA==
To:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] sch_cake: allow setting TCA_CAKE_NAT with value 0
 if conntrack is disabled
In-Reply-To: <20220307182602.16978-1-nbd@nbd.name>
References: <20220307182602.16978-1-nbd@nbd.name>
Date:   Mon, 07 Mar 2022 21:37:48 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87o82h7b37.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Allows the 'nonat' option to be specified
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Right, makes sense!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

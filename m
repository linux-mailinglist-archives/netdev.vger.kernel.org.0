Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645E854AEF0
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241938AbiFNK7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234633AbiFNK64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:58:56 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46421286C1;
        Tue, 14 Jun 2022 03:58:55 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1655204333; bh=3J3mVf8fkTb1aWQ9iHVwbsZZInuzpCUmrtDUqRR2EY4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=gw0X/ikrjQzYjbApomAYSEz95DpMIHqaWENnafSB7pvMqyjIfcvaxBADDEnJ3awHn
         qWPfr+QmNnV2xnPl8Z+MdBji4YMIWBp0MfERPWuEwRtNVPwoHKtflRnW5/Jas71YzJ
         6Q1feIeHHJYMd9LeppeZoVrIhCXlCcKZfDRGyNqxtreBiVOCelaNM/tz6fv/IVT/7p
         jPSO0L10RIAi0W4FXc2jMzqPX/zEBDI4sRmEQd/hBAZ7DqMQwxiDTpm5nDkv4o3VJF
         OFFT8j4PdNF3TLTsAG0yIs0uOMhAvQRatyeinVFrEvPi4woIdu0d0fwwuYQrQCoetv
         egjgHPtv86wTg==
To:     Pavel Skripkin <paskripkin@gmail.com>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: Re: [PATCH v6 2/2] ath9k: htc: clean up statistics macros
In-Reply-To: <ebb2306d06a496cd1b032155ae52fdc5fa8cc2c5.1655145743.git.paskripkin@gmail.com>
References: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
 <ebb2306d06a496cd1b032155ae52fdc5fa8cc2c5.1655145743.git.paskripkin@gmail.com>
Date:   Tue, 14 Jun 2022 12:58:53 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87letzzf2q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> I've changed *STAT_* macros a bit in previous patch and I seems like
> they become really unreadable. Align these macros definitions to make
> code cleaner and fix folllowing checkpatch warning
>
> ERROR: Macros with complex values should be enclosed in parentheses
>
> Also, statistics macros now accept an hif_dev as argument, since
> macros that depend on having a local variable with a magic name
> don't abide by the coding style.
>
> No functional change
>
> Suggested-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

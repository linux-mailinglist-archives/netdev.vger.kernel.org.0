Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017CA4C954A
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 20:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbiCAT7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbiCAT7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:59:40 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA81275DD
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 11:58:58 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id k1so4775874pfu.2
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 11:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T8ZyvWAxfUKU8eszr8lGqQnbfIAMhJjBh1iZNFmklng=;
        b=3dhV6Gv2HAHW50uFpT+nLwsWZZVGEbQKxnzMi5YoapTNs4P/rDnd2ib5ZkmoB4bW7J
         dx3coNTm6UBKXshK0U2WFRSBOu/w5HkXi4U8f3VPeutmEirgTDOwq1Mf6LFXCSI5W0H0
         YRhZpfbey5kCBwTgHywyrMlyMpAPejIt3AxWsHoorKuU3JJukjLyHUzp6mas3nlkd/43
         Yh+Q+P0VFRnbwWZyWmsJgmNr6VVrHNiO+BTe0xdI0Mx0J77XecwqbIibMmeDfo8go2oM
         SVJ1nc5z4rULDFpa46CqGvoe4cGZzpvEhDCrG7AGfzqLdXx8nq9Fwf3R2LBmnjYhW62q
         H4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8ZyvWAxfUKU8eszr8lGqQnbfIAMhJjBh1iZNFmklng=;
        b=MTdMXlbrtNbAqMIm18gEZg2RkcGA7ZsMhMWVvlqVfoO6HVh3DXlSysZAH+IPJOzCsw
         +2aIPb1b9su7Z4Aewavsyxhh5Oz8HCd0C8R6Ygk/GqkU/PJ9XaSIPzY5vG89+15kGF+9
         DuasaG/+c9snYuvipX5ZjI93/DKtG3Qgl7C0eYA13ZoTsEmrLwzjCYXtQaJRXt5EKAdC
         b2X69jaxfHlZqdCT7gpDqIfAcqZ5+5Yt3oQ0akuDLh+K+rb6E967oFndQC/ki+7wWW4E
         2Qkaw3nufW00a9IMIeNmP1yxrcViWHNKTpvX/bvBDdUjto3aX2wKW1ozkXua7v7flGez
         VRZQ==
X-Gm-Message-State: AOAM531mLPZ3Aa+M3YuOjoztTj2r3vkY0o+n3fOg9V6u0jtnT10QbQB7
        Ak8ntOOU0hSwhXMoRPB5PjblLxo0dc2CVQ==
X-Google-Smtp-Source: ABdhPJz6PldCPzmNbccBhufxm3jcEJVRQ6uxXSILOfXSy2W7FRHnJA472P45wgV3TmM+aPfnXvyPJg==
X-Received: by 2002:a62:830e:0:b0:4c9:25cb:e1e with SMTP id h14-20020a62830e000000b004c925cb0e1emr28893038pfe.42.1646164738291;
        Tue, 01 Mar 2022 11:58:58 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id lp4-20020a17090b4a8400b001bedba2df04sm2527303pjb.30.2022.03.01.11.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 11:58:57 -0800 (PST)
Date:   Tue, 1 Mar 2022 11:58:55 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     daniel@braunwarth.dev
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next 1/2] lib: add profinet and ethercat as
 link layer protocol names
Message-ID: <20220301115855.53fe4e51@hermes.local>
In-Reply-To: <d928314fccec204c36979e253b8fc4ae@braunwarth.dev>
References: <20220228092133.59909985@hermes.local>
        <20220228134520.118589-1-daniel@braunwarth.dev>
        <20220228134520.118589-2-daniel@braunwarth.dev>
        <d928314fccec204c36979e253b8fc4ae@braunwarth.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Mar 2022 18:26:10 +0000
daniel@braunwarth.dev wrote:

> February 28, 2022 6:21 PM, "Stephen Hemminger" <stephen@networkplumber.org> wrote:
> > This is legacy table. Original author did choose to use stanard
> > file /etc/ethertypes. Not sure why??  
> 
> I tried to extend /etc/ethertypes with the following line:
> ETHERCAT        88A4    ethercat
> 
> I would expect the following command to successfully run:
> tc filter add dev eno1 protocol ethercat matchall action drop
> 
> Unfortunately all I get is:
> Error: argument "ethercat" is wrong: invalid protocol
> 
> With my patches applied, the command runs without any error.
> 
> 
> I wasn't able to find any hint in the code, where /etc/ethertypes is supposed to be parsed. Could you give me a hint?
> 
> 
> Thanks
> 
> Daniel

Right, iproute2 has its own built in table.

There is nothing that parses and loads ethertypes.
I am suggesting that there ought to read and cache the file; assuming it doesn't slow things down too much.

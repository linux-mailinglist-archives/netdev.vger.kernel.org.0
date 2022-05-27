Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D541E535C96
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350435AbiE0JBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350635AbiE0JAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:00:13 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8135FF02;
        Fri, 27 May 2022 01:56:31 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9d:7e00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 24R8u9Tn990091
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 27 May 2022 09:56:11 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:961:910a:a293:6d6e:8bbf:c204])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 24R8u3412440897
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Fri, 27 May 2022 10:56:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1653641764; bh=DfYbl65Hbc+w0fV0PhHCU3PRq4eV+RpSwpj8SfFkR0k=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=azjOw1m0AJ8he7++0//SPx2has70sZYBFLyinkAm9p3ohNj3Qf1doid7zYZQR2Akd
         5qPAQaOo+1jJ4dBd9lWy00nPsDytsxpsr/ZqCvHSb+BmT9EgleVL6iruqog8G5/mSB
         iEYNlcVo/bOP1iwp/eXIrFFAiC+nR3sfAgY6qEOA=
Received: (nullmailer pid 891541 invoked by uid 1000);
        Fri, 27 May 2022 08:55:58 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Carlo Lobrano <c.lobrano@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: add Telit 0x1250 composition
Organization: m
References: <20220527082906.321165-1-c.lobrano@gmail.com>
Date:   Fri, 27 May 2022 10:55:58 +0200
In-Reply-To: <20220527082906.321165-1-c.lobrano@gmail.com> (Carlo Lobrano's
        message of "Fri, 27 May 2022 10:29:06 +0200")
Message-ID: <874k1bs6ap.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.5 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Carlo Lobrano <c.lobrano@gmail.com> writes:

> Add support for Telit LN910Cx 0x1250 composition
>
> 0x1250: rmnet, tty, tty, tty, tty
>
> Signed-off-by: Carlo Lobrano <c.lobrano@gmail.com>

Thanks

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

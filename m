Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE02743A420
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbhJYUM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237563AbhJYUMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:12:20 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF7CC061232;
        Mon, 25 Oct 2021 12:32:14 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id g17so11317865qtk.8;
        Mon, 25 Oct 2021 12:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3hzO6U0Zz8OFpiYAgnYCo9FQlmPOGv9g9g1Rf5UmHPI=;
        b=PzkpZD+TE29Yju31SHOLaaKav2lGLRJ5crSxR8G6kWfsnza5akTTOK1jA72BISYxmy
         RWWhPlvmJ8EyzBJEiBj8miTjh4FESN6j/pW5gi/uQIi+VqmBn67af+Mo1hEoLwv6kr82
         a6H6vnU/+kxhkrz+4wAUG51xLd11k1YJbTyv8TH+LKFXSzclGFRM/C5AxtDERh/7QMNY
         iMbJEIxoerZiJhmj+U62NUIGUYH1fj0fSyZLrFmH/DLrQngOaIti1UzexBE8Nfkc3IWU
         q5eOq0SNuGwYUVx0uQE9IjPseA46RK411uz37KXSHQ8Oj0ocjg1gSoPFI1d1NUSEsbpb
         4cgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3hzO6U0Zz8OFpiYAgnYCo9FQlmPOGv9g9g1Rf5UmHPI=;
        b=PksuHvU/LQr4GyJ5lohRmvko/qrDrdTZUhPk5ddCAR6C2kojCYnJzWxh9spn6elMfn
         koUXeyyYwqUEV/eSeZsdZIHlsJzj/OpWHBbltseK2+wvY0/4yvVCBLgM2XQfcly8FQRI
         sB9e7mD7gJK6iEfx56FlubbPhZOrWJkPraNcEAaxTPOxP0/hiAOiFC6CZnlmlaQaEfIM
         bbR7apYlin/P0nieM08+bYP3nb1OACL9alouYeA0Km1dMlMuURPzEv6KhPFa6oqAJzva
         MtjAYlt/EGhhkc7YzDN+8XqYoDsOhoalWn7y/+X0wuNxFbTEfojHP8h6jtGt6gCa0AJ6
         IP1A==
X-Gm-Message-State: AOAM532AKq3mIXRDDwkb4HBQLgJEj6W8rXmExrFwbTkd0kh04q7gFj6l
        Omv+23ct1vWpNyEiC/W9hWQcPDPnuLQ=
X-Google-Smtp-Source: ABdhPJyGe8OyaVNMzlzcQJYub0BpqatsjyDm6Ld53oj282XP9OtPgu0Z4pcGesOKJyiSHL3UZwwzig==
X-Received: by 2002:a05:622a:88:: with SMTP id o8mr20124089qtw.244.1635190333809;
        Mon, 25 Oct 2021 12:32:13 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:f433:a0fe:4103:83a4])
        by smtp.gmail.com with ESMTPSA id j2sm1395539qko.100.2021.10.25.12.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 12:32:13 -0700 (PDT)
Date:   Mon, 25 Oct 2021 12:32:12 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: Unsubscription Incident
Message-ID: <YXcGPLau1zvfTIot@unknown>
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 10:53:28AM -0500, Lijun Pan wrote:
> Hi,
> 
> From Oct 11, I did not receive any emails from both linux-kernel and
> netdev mailing list. Did anyone encounter the same issue? I subscribed
> again and I can receive incoming emails now. However, I figured out
> that anyone can unsubscribe your email without authentication. Maybe
> it is just a one-time issue that someone accidentally unsubscribed my
> email. But I would recommend that our admin can add one more
> authentication step before unsubscription to make the process more
> secure.
> 

Same here.

Fortunately I just switched to lei:
https://josefbacik.github.io/kernel/2021/10/18/lei-and-b4.html
so I can unsubscribe all kernel mailing lists now.

Thanks.

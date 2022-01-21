Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D64549677D
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 22:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiAUVmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 16:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiAUVmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 16:42:54 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D29C06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 13:42:53 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id y15so28232482lfa.9
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 13:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=S3JtR5HtN5TgHtZRkOpXh8ju3yrdK90cRx1M8SbEib4=;
        b=iZL+aW3eJd5ghptgiXiwWVp8d6TBga0rJkZIHt8ey2gNxVppHJCIJ9frQTK29Z/p7p
         ovz7tb2KMBLBt0SKLu1FLJkXwH8Zp/yw86YvrSvhn/PD2ewybs2TcDd5EY+uK1h0e8Ss
         sbQcvIfIZ76REb3AS6KaecGV9Ad3PiNjG0aG4F3FnD8LNSnUOz5bnrznPnVlJ2QrGhJY
         BwjrBR6A0JtAQ3QhSa5G1aWFl0O1CaysJkycu9tAY4dw7ryTFFx1YfBc6X5hXqGluthc
         NW7GbT8Q+0a7Mep7+yEYfQnbYpZVZOm199rVrv0wJ6wUaSLtGzPGhuStmSBmGa9Ae9bm
         CcbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=S3JtR5HtN5TgHtZRkOpXh8ju3yrdK90cRx1M8SbEib4=;
        b=BpEbNYIns4X/4AqoabyhBjn2uDTn0DOoIH+SKGTsSYYRcfMO/Wn7QTFe/Nf89q1oOz
         CCqoGjTtd2gtiMzdWV4qGTwA8o74l07djm0Q87mKmjMRRA7hCy7lWYR4bovshza4kx/o
         GZJEAjh765mNG1oRW6Faoj1zV2wf5vRM4n7vDjvcRqIC1S9Kw4IGqsEq8hDLT0rrhs6h
         pmvSvX2hwmm71klnkuwEiWmhftDPZiYWnCarBzqKm5g8+ekRy2VSUWOPav3Gf729PlTM
         vYOPSJ4Atga6VTACmSoS8G2pfjkm9SWcbI05Y/JPiatxab03lzXm9PuuMqvCzMdcnhuc
         hjqQ==
X-Gm-Message-State: AOAM530NScIfxzlmG0Fr6vxXpNvwjfUnavBoGsT1leLdf/FHGote8Jkm
        cy6D6dtQWLNy1wmc4IyVfHjrxDT+N5P13hbUo5g=
X-Google-Smtp-Source: ABdhPJyeZohnC6EkswCG+cziNpW+tLmS0ZUHFPGVEeOCC8ffyHnQ6cQ2SHyCRzxJ+iwZao4/dtmhErq/eORUMkNW15A=
X-Received: by 2002:a05:6512:12c9:: with SMTP id p9mr5152279lfg.97.1642801372012;
 Fri, 21 Jan 2022 13:42:52 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a2e:aa14:0:0:0:0:0 with HTTP; Fri, 21 Jan 2022 13:42:51
 -0800 (PST)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <xaviergbesse.2020@gmail.com>
Date:   Fri, 21 Jan 2022 13:42:51 -0800
Message-ID: <CABEvWUJ+6+OvgWm6RZdWeYRCOg0Dg4hRKN9TjXaFOagtfB65rA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Please with honesty did you receive my message i send to you?

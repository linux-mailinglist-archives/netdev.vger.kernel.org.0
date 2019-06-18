Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E984A7B4
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbfFRQ4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:56:49 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:47092 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729472AbfFRQ4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:56:48 -0400
Received: by mail-pf1-f193.google.com with SMTP id 81so7989807pfy.13
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 09:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9LRNuMm4LiXXF3Le55S7RvcI6ibwrHY/gxWEhLmKC7w=;
        b=bh51mUqLr4s/sPB1C8w/W70TRj+CSHB5XzYSPH94yX0ZPNiUtcZkfr6jQ/w5iHg/wY
         FTgBifM/ROfTe+jHGrLr/6ynNrcSSSI0qhQabb2Tjk7zjk6Hd9A5lTSqalKxq1/1NlOD
         U8T+oLwKvfBN8qT5Ykf10BSXuDBaugNlaviH42lTT9j3Qo+sn6/yeMv31Fc2FGYTVzFI
         Mp0N8uGScW5Ir7zrddsz6asprs8VMh0rBsXbUqj/YfZ1oJw6HAB626ATP2xozvwtG9nd
         IZlbURiRhjKwfgICqRWfwMLDflW4U3VI+AfzcoxYxo9CbqyN6grQzm8qaoEJVowzR0op
         /zVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9LRNuMm4LiXXF3Le55S7RvcI6ibwrHY/gxWEhLmKC7w=;
        b=sS72oOvTE0KQfdcQ85EGGjYr+LzmLUZhIE1ndkUQADZw167qu7z+Ugw7gfmu+fANWP
         huMjHKz6/eVsKKhaCF/vEtOZ6jqFfmHA+I1ako4Dr6GBdRf1oO2WVtMD6b96KuVui98v
         aXhwyuHR9vIDzux0GQ15KuRgfiDTQD4v2OwlGOm5HcIlO7e8nQ2H6scpb3mVyjUDtRCc
         dT6Pn6X5f8FtJ6v8+l6En3OcxAWExaN6fDlGnUNkiTljkwET9bpYjFDNw/gorsUjeMgv
         kFAvtuWfE2VV6wk2R6HmCNIk7gaZiy2Ze20JNue40Y12LsSB9cd+9AvOVKDFYd4n8yiL
         QzTw==
X-Gm-Message-State: APjAAAWrrMua4ghZTVG0oGUyzD60WNA0MGfk0Vg4DhICyOv1sADqto53
        Qi/8TRF7Z7hEPsXgrJE7LHEZuivxdmQ=
X-Google-Smtp-Source: APXvYqzJyej4oaQRSmPWxUi5DHvPOdvc7/WjIev8IZ6VptCba1u1ETJrfA/jd6vJP+e/sFG5Mp8kaA==
X-Received: by 2002:a17:90a:2562:: with SMTP id j89mr6128931pje.123.1560877007963;
        Tue, 18 Jun 2019 09:56:47 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a12sm14774802pgq.0.2019.06.18.09.56.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 09:56:47 -0700 (PDT)
Date:   Tue, 18 Jun 2019 09:56:46 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Pete Morici <pmorici@dev295.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] Add support for configuring MACsec gcm-aes-256
 cipher type.
Message-ID: <20190618095646.2b9de8e9@hermes.lan>
In-Reply-To: <1560533099-8276-1-git-send-email-pmorici@dev295.com>
References: <1560533099-8276-1-git-send-email-pmorici@dev295.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 13:24:59 -0400
Pete Morici <pmorici@dev295.com> wrote:

> Signed-off-by: Pete Morici <pmorici@dev295.com>

Looks fine, applied

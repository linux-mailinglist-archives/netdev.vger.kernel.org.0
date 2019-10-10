Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52C3D1F4E
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfJJENm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:13:42 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38324 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJJENl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:13:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id h195so3019377pfe.5
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vDCFCwzkObP7JGkplInNr72QnOvVnuxnRx9HfUiMirw=;
        b=ruCZ2qqxsaWGzOgPFm038Sqem5xwPrEd9zdOnEe/JFRotELEDEbAcr2x8Tt4uWdQap
         gDHi3tbS8H5au7D/TlrMI8Re2YgAAA0fKwEyqIfaAGKCb+We5SNHnHhQHWwPKHL0MRLW
         bR6jX/jDOO5cgAgwSiK0GWlbSxQPtCdXzcQzete+uQV7AODbnXbrZiJRb0R/DUti8pGH
         YjmB3mCeKZXbq//vqUSXyhWi7+i7F0/Vw/bJ/3hzeWpQnHOkqdf/WSgp5FxeA4hFv94z
         xcwmqn8CCQ0/lA4NjMZsmPnPV/AGPfdU0bu0CEmmDzqx2C0e63tLAlHMukn8WRCAkhNC
         Qdlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vDCFCwzkObP7JGkplInNr72QnOvVnuxnRx9HfUiMirw=;
        b=HOlh+MqD2RkmfhOyS/qbZ6O3spnAlUpJj+bGmBbOIiQWv1DuIPSB9GZAwnJkYdRBbp
         Ebmxk0wRjH8dsXzmB52OwrRJnvdaMK7Bh0/w5kZtU2K1jBcr6Fv2xwZyyg4YXhIac3Xf
         tnFcOTDKkp7xyJbamp3giub24bwNVus6a7l3G9pLd5OZl9Cqm2gpAPIhvZ+JiwLpZ8Sv
         sSpjTd0dZVbIsNWxw3hHkW2HmtEUDPQMs0V7ChY11IVB/CX7MFi+3gxlq4Coq1GPdd0Z
         IYKkp6zGsGJk/McyEX+ciQJBDg4Fagoi5yOZ+xN/R8ji96ubzhLSfU+d6Z3yrwjeZXwK
         q0ig==
X-Gm-Message-State: APjAAAUqVrwiexpux/PxDLO/yJEFwAIkt/VbO2JnJ/m0oz8NM1LroMIx
        QADa3PoGKVCzr2MqJrJzHIoTcg==
X-Google-Smtp-Source: APXvYqwQwDUf04LfS+9wee5xHUAyA677nCw5kRENAmP1KdsVpZKGMatz2kceYNmfogMKO1oXcUOYXw==
X-Received: by 2002:a17:90a:e652:: with SMTP id ep18mr8885568pjb.72.1570680821004;
        Wed, 09 Oct 2019 21:13:41 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id v28sm4250235pgn.17.2019.10.09.21.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:13:40 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:13:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: Remove break after a return
Message-ID: <20191009211327.7e707d36@cakuba.netronome.com>
In-Reply-To: <1570631340-5467-1-git-send-email-yangtiezhu@loongson.cn>
References: <1570631340-5467-1-git-send-email-yangtiezhu@loongson.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 22:29:00 +0800, Tiezhu Yang wrote:
> Since break is not useful after a return, remove it.
> 
> Fixes: 3b57de958e2a ("net: stmmac: Support devicetree configs for mcast and ucast filter entries")
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>

Applied, thanks

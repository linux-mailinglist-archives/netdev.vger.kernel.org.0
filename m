Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEE81741A2
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 22:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgB1VtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 16:49:05 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42374 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1VtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 16:49:05 -0500
Received: by mail-pf1-f196.google.com with SMTP id 15so2368386pfo.9
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 13:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0HbNbeB7e1helNnmZbFPkwWSE2TTIQWxHgGDuHAEWCg=;
        b=TkjLuRNaT3etHuahZvsiL85VkCSIrmMAnV++0B0Z/S68L+rtbwZ48zvv+oRNBGIG9G
         yDjOqImcKYqinQKdEZKjhA3c8rub2cxD4igN/8YFZNIMIJYqSUwuue6sV23B8sejmCrw
         zbiAhSUvOOzYeWqfWzLpZd7QhbdfqJ2PdkxbIbSb5wdAwlgHs2ZTCae0S5l6xg/sKlIJ
         y4lj4bfw/lWypijPBijugolA9l6xo5D4qwG+cduOw1sVXeqpUHPfArcm66jT8NbYiwnL
         sKeRcaaOKEeV6nyyfpdBqySCGpa6sZimdayUv9bCdgKKlPOtKaezYKDJKqaJew6wAnaO
         UIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0HbNbeB7e1helNnmZbFPkwWSE2TTIQWxHgGDuHAEWCg=;
        b=csW6NWT3hhiaYLyWpQHmpLCnNvsLDbXwXFbjQa6IO/9M7FENdqpUrZDR5x6fSM7a8l
         5dH8GzEaLFTh1Z7sSZ4MLvW3rS2wB0XljwNkyrtJ3CITiZRWKjbu0q4fznw7HPWajeb1
         +TY2f9VTvQ2OLNrp+Scd2PoRFpXGfP+XXmPMNIxqkK824xrPKfGXvDfd5cfVUdMmWNA/
         7Kf0zQvmTbpTd/KI63IQgYHToNOpjs6ad2b3g8wwClgHskn/HXkor8JIHUDxc+76CoFp
         YS51aaoC8EUBtVrhMNXMrbxpqr5IzLgiTLe6ger6w97AQZ2xkTZgJYSwTGTyixhRa3Ni
         PJ2w==
X-Gm-Message-State: APjAAAXVCED2nZMR+sZ/Gk9RNEdZ/jKP1VUufS+FJ/lJ55sugiDSm5Yw
        dTAK9ubmEINaUKMso+MOLPybHw==
X-Google-Smtp-Source: APXvYqz3Din8eHaAx+263OjuuOAQPAcbNyUhDel+DaQOdHt+rGonY40fwiHGwJOkCSlM2MZTTbOLPg==
X-Received: by 2002:a63:3449:: with SMTP id b70mr6618836pga.242.1582926544420;
        Fri, 28 Feb 2020 13:49:04 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 188sm7782042pfa.62.2020.02.28.13.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 13:49:04 -0800 (PST)
Date:   Fri, 28 Feb 2020 13:49:01 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2] man: ip.8: Add missing vrf subcommand
 description
Message-ID: <20200228134901.6449358a@hermes.lan>
In-Reply-To: <acd21cee80dfcb99c131059a8e393b6a62de0d64.1582821904.git.aclaudi@redhat.com>
References: <acd21cee80dfcb99c131059a8e393b6a62de0d64.1582821904.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Feb 2020 17:45:43 +0100
Andrea Claudi <aclaudi@redhat.com> wrote:

> Add description to the vrf subcommand and a reference to the
> dedicated man page.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>

Looks good, applied

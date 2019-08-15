Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24CC8F249
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 19:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbfHORdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 13:33:32 -0400
Received: from mail-qk1-f176.google.com ([209.85.222.176]:39741 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfHORdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 13:33:31 -0400
Received: by mail-qk1-f176.google.com with SMTP id 125so2454877qkl.6
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 10:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=XBZ4izAjS/kg6W+biN02i42pK4zuTptrBFn0JYYYY9Y=;
        b=JNwm8DJ7uPLvwYoP+lnGGpZyxEWo86v/fBzK0ekKvG0bafYnyuwbDG4aRpYp68ZVeZ
         VuK6fc9475cFKP0W38I30oxBrARQ+DG+ARYpYBBiKIu17RouXqxn3kLhHTYKxXJbZV5K
         uUf1tA1mAo/gTz98Xoc97DE0WLAOpzh6fVXa58dndy9lP5pcG7vcFR0AL7LQceDrM3Nu
         IRBmke+W5Eu/y5lRyu1ztYNGiwXLX5pes7YBYpLr4QsD9oJLHiSmaJ/nUIt+pBDzc6jr
         9vG3Gm0YPfOtY/sN8OhpB0+wnh3WaxN1G7Q2rUq8An8bLYSe79ygq9pTa5ib+N/urwv0
         WSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=XBZ4izAjS/kg6W+biN02i42pK4zuTptrBFn0JYYYY9Y=;
        b=l4QtWLt7DaXZw7gKhqAGo/kdDr2gCL2OGrnfOmrT7Nfx1mI1CrTcIFDE+PsKYy43Us
         GzqSIq8ZPAwdGhCW6XlaZA3BhhpB9oZQOH4WHxjgYGl75FSXhnYynXT9n/kBcdEaIis0
         0QVKG53Y/WMp8vohvc1aZlqX1JxGVRH3ZH2ltYzqeeINOX6Pw1pOjwAXKmLKr0o2B2d9
         yanuWQMMF3YIr7x3LgjNNQIDBzlULRImwd6hxIF18hez+xPhvKEUzvzHMQaD0eAeJjOu
         roZCkGmIz3T2onSpae0leMe0nrIcOU3ncYB8fZyc+hjJcZIaP4GwlZ+0bJX+XkwWJbFz
         xmVA==
X-Gm-Message-State: APjAAAVwS/dZdd2N3Hv95obIxgzyjQnlazw+nEnAL59aC78dGyKbTb8+
        q32n78gaz78nyoXwMykZBVnUOA==
X-Google-Smtp-Source: APXvYqw5w+XikmkgCrY4hIHYOiBpKMr5/UnyNDoQI/NXr3LhepO5vdTu1Hv339STN7wn32SWKJrIeg==
X-Received: by 2002:a05:620a:16c8:: with SMTP id a8mr1373906qkn.234.1565890411064;
        Thu, 15 Aug 2019 10:33:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t13sm1712384qkm.117.2019.08.15.10.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 10:33:30 -0700 (PDT)
Date:   Thu, 15 Aug 2019 10:33:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 2/2] selftests: netdevsim: add devlink
 params tests
Message-ID: <20190815103317.3bc6279b@cakuba.netronome.com>
In-Reply-To: <20190815134229.8884-3-jiri@resnulli.us>
References: <20190815134229.8884-1-jiri@resnulli.us>
        <20190815134229.8884-3-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Aug 2019 15:42:29 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Test recently added netdevsim devlink param implementation.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Tested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!

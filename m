Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0435DB128
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 17:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392768AbfJQPcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 11:32:23 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35747 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388925AbfJQPcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 11:32:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id p30so1579213pgl.2
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 08:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/D/nNZscZ1K9IDVaCOyfYn9u08ybo0MTWSdAdAgJkns=;
        b=lqnOu2FLhPmJBR5lEPiKsUgrUBxRRKM1p5fI0uJrYDd2WdZo/M/Qk+xMQwseWCxbZN
         YLSmHwEOSsngy8ceHCuuGcAHzfQ9BttQLYMP63sMcK7D2tWvm9nIrgc7vE5PpB7rNMPS
         HfZ8WsJG3E4vw8MOL5M4zntPNTWnGOR4Ee9j7AZiLwrJhlJXO5ArGNSbqEaQ9JQWj0IX
         hZz1Znpu1qCoJD4e99scW+uGaGbhkhqaKzVT8+BmaTy023dXmy5cjTaqu6ZaB6tNJ8aD
         fAw8git/xSmwaxUgJvtbnDZgDxof3k7SdGQdSedZat2UZXzks+3OiNSrI6/6/YPWmcLT
         jY8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/D/nNZscZ1K9IDVaCOyfYn9u08ybo0MTWSdAdAgJkns=;
        b=ce8V4tjo9r4qrJLUAQSn1BaD35MDztORy+OQNc83nA22arshbabGPWzFDMLQWby3qz
         lKduMQB7wNyxY36KNc0k2vDpeKrI6GKZ4UZk4vcVPk9kzKw2MtWMd0qkNPt3kFE/p4yP
         WRwjsoqLr6xVBhRwy8GF/E5fGLJVTCki4OGZBS8s9kAWk/mnMwqrzjfHtlSNMrdEy+/Z
         ZgzA8AM49IGTlsdwdaXMZDhpQJSbnY6si466q7ND4qtkpmBRz3D4GA4Y82KdpMwPzQE3
         CIj5372fKWnJVZLVeBGPzQEI6hueeuP8ZuEwe1e3oelPgMsCGAX6QQqhV0VccI7o/ABT
         tbTA==
X-Gm-Message-State: APjAAAUXZbQPBAXWFmrDyMd212ttv7HCouMnxL+E1fHbYc+FxTjK9KcN
        pJUU/Cfb7oOeMrZ26DVQXlLdfQ==
X-Google-Smtp-Source: APXvYqykqnsAf6VUtxGgWe+ZNWmCRuvBiSHGbdcPywjFEo9od6OY1ybYySiUBUJe80S7DkbERh2L9A==
X-Received: by 2002:a62:e90d:: with SMTP id j13mr843875pfh.86.1571326341902;
        Thu, 17 Oct 2019 08:32:21 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x10sm3162454pfr.44.2019.10.17.08.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 08:32:21 -0700 (PDT)
Date:   Thu, 17 Oct 2019 08:32:14 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Thayne <astrothayne@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Documentation for filters in ss
Message-ID: <20191017083214.5223cbed@hermes.lan>
In-Reply-To: <CALbpH+jEOPxfpTXiWwbPKKwueJW5W5Nxb1vyagyk9Tyj6H_Pfg@mail.gmail.com>
References: <CALbpH+jEOPxfpTXiWwbPKKwueJW5W5Nxb1vyagyk9Tyj6H_Pfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 23:17:53 -0600
Thayne <astrothayne@gmail.com> wrote:

> The man page for ss(8)  states:
> 
> > Please take a look at the official documentation for details regarding filters.  
> 
> However, I have been unable to find any documentation on the filters
> for ss, official or otherwise.
> 
> There was some documentation that was removed in commit
> d77ce080d33370d90de8b123cd143e9599dc1ca6
> (https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=d77ce080d33370d90de8b123cd143e9599dc1ca6)
> which I presume is the official documentation referred to?
> 
> The man page should probably be updated to either document the filter
> syntax directly or point to where information about it can be found.

The old latex stuff was only in the source, distributions did not know
what to do with it, and it was never  updated.

Documentation belongs on the man page. Patches happily accepted.

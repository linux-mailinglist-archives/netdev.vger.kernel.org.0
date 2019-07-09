Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1166306D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 08:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbfGIGau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 02:30:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38494 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfGIGau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 02:30:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so9474511wrr.5
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 23:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j99cdTsC6sjnJAStKho7TAAhPXIKKP3jHlFcSv7qELo=;
        b=A1WXUS1XN7lribQB0ZfRPlq6FMPthS7SpY26wOTRly0wj1K9Y6zgwHZFan+4fGZr7N
         /6ARAD2aS0iToKEiL4S6I90m2Zu74ILwkF2dxzZBcuklKxxtTovOfrw/t81yZ6GhcRT8
         TGM6vR1e365Akj0PPYaRgumCsuxj8FUsm4ePtVTlj2Pvjqno6NjA8AByMVOu281v2/6r
         b0IZKPIZccWfjgddkGMJvixre1KHGLLKZm3GuU+gPc2/V1FOtGO9vVwMG6LLsvzrNQ/p
         46pCiqF8z3u2C3fRsWB8PCI0VUEtDQHt/AbLovKFA4XUjF1xkH7lvKLkIBuIDt7myW+T
         vN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j99cdTsC6sjnJAStKho7TAAhPXIKKP3jHlFcSv7qELo=;
        b=Kro7dkpjU6Ahi65RV89mYH86lCVyg7KqFjTUloj6y9dP6Rt1OVra+lEDZ0UWGwYAD+
         04g8UjQl4iJVyqGzWUgPaMhI8gyj3zM7cLjgs5HxeAL9vwdqxYT45b25s5S7OFC+R0I+
         21qw2P4S4YeI9avGEEoRMNob1JBje2BgUmHHTy/Egzl/RrODT369uZCA0ttL+tiuOFFB
         J+ZY6wDfL3YsOkaAWVmWIP3xJ8p446W1rNkePZynMgYtE+mQrNDYwq8X/+is3+rxMOn0
         pqDt+4vj3pE/HFrzMVtm0c2Ho9H0crrKiL1YWRS5LmyRMuHvZP+UOUdkc6TWoBXrc2S7
         kEUQ==
X-Gm-Message-State: APjAAAUMUekBD5qyFG9/nlJm+ePCkby5EIGRc4gncZYM8VuJQaGWFRLu
        aDG+Xe3lSOzEPsS0N6P1w/gvfw==
X-Google-Smtp-Source: APXvYqyYX5B0lniJhXyq5S16E3LcYYv9K+h4nmiQBZ0xMfrk3WPF5/bubI1YDc0rj6o0inXiwC9Hzw==
X-Received: by 2002:a5d:54c7:: with SMTP id x7mr22831114wrv.39.1562653848967;
        Mon, 08 Jul 2019 23:30:48 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id x20sm3421634wrg.10.2019.07.08.23.30.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 23:30:48 -0700 (PDT)
Date:   Tue, 9 Jul 2019 09:30:45 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     David Miller <davem@davemloft.net>
Cc:     michael.chan@broadcom.com, gospo@broadcom.com,
        netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org
Subject: Re: [PATCH net-next v2 0/4] bnxt_en: Add XDP_REDIRECT support.
Message-ID: <20190709063045.GB621@apalos>
References: <1562622784-29918-1-git-send-email-michael.chan@broadcom.com>
 <20190708.152020.327516269485719584.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708.152020.327516269485719584.davem@davemloft.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, 

On Mon, Jul 08, 2019 at 03:20:20PM -0700, David Miller wrote:
> From: Michael Chan <michael.chan@broadcom.com>
> Date: Mon,  8 Jul 2019 17:53:00 -0400
> 
> > This patch series adds XDP_REDIRECT support by Andy Gospodarek.
> 
> Series applied, thanks everyone.

We need a fix on this after merging Ivans patch
commit 1da4bbeffe41ba318812d7590955faee8636668b

page_pool_destroy needs to be explicitely called when shutting down the
interface as it's not automatically called from xdp_rxq_info_unreg()

Thanks
/Ilias

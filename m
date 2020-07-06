Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DAA215DE7
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbgGFSET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729632AbgGFSET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:04:19 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A6CC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 11:04:19 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j19so11873377pgm.11
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 11:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ut4HFBsEh29ptxxlJbvMmMtEdhl160i8B1dbFQM+jv0=;
        b=PZglCRKiT9CvpbPgjBFx8KQfyIFKpnj/QPL3upxo9bUFiV6LzK2onfUj/ThrLZ/1FN
         LFmqdw1YKtyuwOT1sKsqfzOPxhnQPBUNnaSBeoQpR+i7gg7mE9dF24YYFYEnclWt0ed/
         iIhUopqDleEJOCkwbEC4Z4Wt8WW1y2sPlYTJ6kzLIQjC+j6daCmCTC41db88OF4MpU7s
         xcTJC7sMH5qnJZC03u/rAcmg6vRR2MXhmo1k7cjojG4Ub7+XEm/Suxe8a+DjAKqb064y
         htsDFJmZYqZ+W3Hjx190tzJ41R1eGUKDhLyGNAQaG/ELrwPy+U1hklyFMM+w6qK5DLUl
         DhKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ut4HFBsEh29ptxxlJbvMmMtEdhl160i8B1dbFQM+jv0=;
        b=YSnkpPm+WCGxWYuDrbedQPgKaa0wzGaYqbHlGaFWsWH6tNA2qJfPUCHhRgf/v7tER5
         IV2Ej6Ib2ctJk6i3FJSWdDhZD/vlLm2QuiiCQ01UgXqBxuakNMtsiAnthwypm24fxi1v
         CF2yuS/NBhIdCSWqSKy8f74G5KwmCX1e7R9ta03GBu/e+jEsLy8U75zBZArl++88SQVd
         b9eEOWse73oWbbXT6T2Iff6RqfwxAKz0HJY0YZEYJv4RhdhUMZDzYUP5AAXC/mr/mRYi
         0wiLYDym0CznBE6iPP2IAQ8HVnlVvz0INWly+6nPARTnGBapuQLYgqsk5Wk7AH+i3VQa
         QP6w==
X-Gm-Message-State: AOAM533+RRGHV/K98YgAFpwCxK0zFIUUvZKA+/oGdl6wotMTQ5zStv+T
        ffkEa4xGZ3TggCTuAZ8ZYqyB4vireOk=
X-Google-Smtp-Source: ABdhPJxD9ioxMX0zKuh6/YlK63k20sXNHjs02bc9v3aWN9F72NpDLRvmxBe3lEjUaphl8LgHzar7SA==
X-Received: by 2002:aa7:930b:: with SMTP id 11mr41380284pfj.320.1594058658531;
        Mon, 06 Jul 2020 11:04:18 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id d14sm137064pjc.20.2020.07.06.11.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 11:04:18 -0700 (PDT)
Date:   Mon, 6 Jul 2020 11:04:10 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Sorah Fukumori <her@sorah.jp>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] ip fou: respect preferred_family for IPv6
Message-ID: <20200706110410.0d559006@hermes.lan>
In-Reply-To: <20200625210712.1863300-1-her@sorah.jp>
References: <20200625210712.1863300-1-her@sorah.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 06:07:12 +0900
Sorah Fukumori <her@sorah.jp> wrote:

> ip(8) accepts -family ipv6 (-6) option at the toplevel. It is
> straightforward to support the existing option for modifying listener
> on IPv6 addresses.
> 
> Maintain the backward compatibility by leaving ip fou -6 flag
> implemented, while it's removed from the usage message.
> 
> Signed-off-by: Sorah Fukumori <her@sorah.jp>

Applied, thanks

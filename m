Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBCED9BC4
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437151AbfJPUZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:25:55 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35368 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437132AbfJPUZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 16:25:55 -0400
Received: by mail-pg1-f193.google.com with SMTP id p30so14966998pgl.2
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 13:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aV5wc2o7LUuO1XrbxPxqxCDtRqFeDwbkjNHERvjffnk=;
        b=sZ+wlvh99rwJICRWeW50MQBll55WZQLlYpkBGauBTeUD3Y8u7K1bSxmI/r7kp9jEDs
         /MNODO2uq7r2oqePK32RN6yRV64cO8ERgXzAAnGFLg5lxySRgr1QTkUQ1HIxZ2FzyXso
         dh7ON5EPaXesnGoB0CT4LlYVBJlyPZmxcdmR659PLCxYuRg5NkplG5jE7vt6qRxSSFhA
         ORcIKGfE6pvf/1kN11yVL3XTpFmeDi0foG3Nb2s48fRnke4XGr8V+CGjP/1cr6dA4ggD
         Ng8qB6PT0eZ4GtiNiYMPU+RKz9/rpJAvplTxt+Ng6rmRpWhNd70UXMwfR0yzQC3RNgp2
         JieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aV5wc2o7LUuO1XrbxPxqxCDtRqFeDwbkjNHERvjffnk=;
        b=bL+hVTspkAwaccnfae83t+G6wHrVUDRkkCNJNtxKztbcqIGuS+X5txZL2Xu8eOebLh
         8rnc5yIuriB6VRmPEScTGFsv5DgIv0gKN6ijju5wQWcx7sqsqjr0Z/E3u6pVBGRZyij3
         WyO8dTAC6xmdJO333r3NLUlO24FTCZScoajYrjvJDbkoRbgASwUDSjBIPH9jIbBfDcMu
         S+369cmkf6jNg1Z7fl0KFgs0BIGi8DbEwDhPKY3vrmn2yktdNK0zOEnMk/727yZVEaeJ
         efAbirkd23EhVJGxIVBan8rCF4VN7YQzVTVylgwPZ5WR4+UJKH8vU3dyLURzz+KJgoH+
         LHNg==
X-Gm-Message-State: APjAAAXH7MPH9IUXGk7ls6taWoua6W+SosLSj3pwztHH4U+EalMbHA5d
        Yt3ekrTyhkDA2js+QDPpMyAc8A==
X-Google-Smtp-Source: APXvYqxc9tLFvSND4BnAuUgOJKA+LxDuTZFKyhFCrMsB0pEIaKd3gZ9JHIHjjWnf8+A5huwoxcy/yQ==
X-Received: by 2002:a17:90a:db43:: with SMTP id u3mr7037459pjx.54.1571257554627;
        Wed, 16 Oct 2019 13:25:54 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h186sm34122836pfb.63.2019.10.16.13.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 13:25:54 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:25:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2 1/2] ip-netns.8: document the 'auto' keyword of
 'ip netns set'
Message-ID: <20191016132551.4ad79395@hermes.lan>
In-Reply-To: <20191016150052.30695-1-nicolas.dichtel@6wind.com>
References: <20191016150052.30695-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 17:00:51 +0200
Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:

> This is a follow up of the commit ebe3ce2fcc5f ("ipnetns: parse nsid as a
> signed integer").
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Thank you for following up.
Applied

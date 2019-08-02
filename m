Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E17E80255
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 23:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732711AbfHBVy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 17:54:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42345 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfHBVyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 17:54:55 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so36651481pff.9
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 14:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wyeLKPzC0XuP8gjAGSTKzaHtBOr+XkQRHretmBzwq5w=;
        b=GaMOsF13xxb3cD8xzf2OmnaaSbtiMzON8fo3xA3vPmsrWVsWsYdLUNrKFxJcx2GOJ0
         Hf+j9m5qaI0cA9ItiutImpnjd17gBDapDOyNUknduvJ0s3uZKttckWEwh6/TaqPb1NuK
         MC+xNZlOytC+TjDD36ADL1bINhIbgY2uLhUPpElNVWEw+YsHmuamej7D0mP74+Srk496
         60N4HTArbE3YzdC5S6kdKMKfqpZBgOD9OPX17vjm7e6Iini9LdUGlPOSWf1LmHLdO+RB
         9xM1m8xJw4J33uPtbtqirl5MhIHcmyCjTqI0OjmGrLbDCPflVJ9EY6JisOEy/teLwzpB
         5siQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyeLKPzC0XuP8gjAGSTKzaHtBOr+XkQRHretmBzwq5w=;
        b=FNEfGTFU5aeE1tYEMTzdJ3Dbylre5t8ACJHgL227kQ9N1SH27NYO2JofXw0dFw/BZC
         P5nU5aSm6WjK9H8g6UgYZZwYrY0yng5QA0uXeFn/GDrCaidD05Ox2cG8NYRITdGGn12D
         edGQB3gN9iW7zPeQl5T9qsyyRuJxdg/3MILFpnYk8uauJD4QeUjy++caalEAIqQGm/PO
         2pcNFkEoZenbpr19iJILBYus1hG4eX+QZJ7uVr9tbnKgVnEvWtUiSewUgvbavjT7zpod
         dr34UFeC1YXvSceOPVbj8rgkk+OSGpke84yNATcLlSrlBF5fozFB9jYVGrOMAFXJXQqJ
         Eb5w==
X-Gm-Message-State: APjAAAUMYeX9L/IJvlMMJUAG/U3glrXBBlJ4s9F9guvSSH6hseRC/WPu
        Dq4dwcd+ZoCNpDAvnrN+QTY=
X-Google-Smtp-Source: APXvYqwbHMg3jNoCFZHog7Hxf1IYqhk4HkeR6DqQNTGvD37LG2dD5fYELrYf9ed2PrIB1VZBXPindw==
X-Received: by 2002:a63:3147:: with SMTP id x68mr63386647pgx.212.1564782895104;
        Fri, 02 Aug 2019 14:54:55 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id m16sm75782068pfd.127.2019.08.02.14.54.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 14:54:54 -0700 (PDT)
Date:   Fri, 2 Aug 2019 14:54:48 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ricardo Bruno Lopes da Silva <ricardo6142@gmail.com>
Cc:     isdn@linux-pingi.de, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, lkcamp@lists.libreplanetbr.org
Subject: Re: [PATCH] isdn: hysdn: fix code style error from checkpatch
Message-ID: <20190802145448.0bcd5374@hermes.lan>
In-Reply-To: <20190802195017.27845-1-ricardo6142@gmail.com>
References: <20190802195017.27845-1-ricardo6142@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Aug 2019 19:50:17 +0000
Ricardo Bruno Lopes da Silva <ricardo6142@gmail.com> wrote:

> Fix error bellow from checkpatch.
> 
> WARNING: Block comments use * on subsequent lines
> +/***********************************************************
> +
> 
> Signed-off-by: Ricardo Bruno Lopes da Silva <ricardo6142@gmail.com>

Read the TODO, these drivers are scheduled for removal, so changes
are not helpful at this time.

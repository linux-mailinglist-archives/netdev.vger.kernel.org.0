Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AA514A571
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgA0NwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:52:24 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:51410 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgA0NwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:52:24 -0500
Received: by mail-pj1-f67.google.com with SMTP id fa20so22646pjb.1
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NlXj9KW0eZtSCliOVig/+jCW/RgGOhDmKBf672iVsr4=;
        b=Z4j9IzznNqyg3vueP/zEYNbKF+DhEkxhI8fvOYAmzZ3XDo0p5CZUUxUUnlX8oAzDi+
         RFukzDUyHdNVbRrIvVuOy5Xin90dy1oCRzUuK6iF/4A2e3NycM8KcWct8u/WF4rkWa7h
         /OuQf+ceh9jcQQ5Rl0honr2m9CJoU5SYcC9O9fAIe4ZXgpOyaBc1dktt+BDq9gWGe53V
         oBmhyj8PTGvKJ39q1rwn732mFDv/fZ8DN3iBCuMibQPKtYj5Z9Xy7MArRFBTXKLiyeby
         DzyHMa7ahifkCiLD7f99Zuf5VCVb/5JJ+HuMLS7dAk+FR5rpizE+LMUk+rK8np6V914n
         vwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NlXj9KW0eZtSCliOVig/+jCW/RgGOhDmKBf672iVsr4=;
        b=ffD4illpzEsNCxBUN/cG0z4GNTIGGGOkDVAimVXQqOmCPsMaYBjkBjHTEce/yiK6rF
         w1GSa7aewXNbv7khJR0HpXJ65bigYuxzRfNinr8id41EFPqaqYNxNc0CpworPIEZIN8+
         hQtrYDIcp0nMROloHaUFjBv9ZEhQ0Mdd7BsW2sTBL8IKO8UICZo04XDXbmUzFkopKW89
         AuZM2ymKXLlMauQ4q+7I5wQ9KVcdhwv+5jt1EqBu9Yhz3wTQgk5nFQhVUr2Y844qWxOs
         7+5yclbi1jdxwnGsH+QVZ0AexLmgbQJLXpBe/6ed/tlGD/O2tr7KqjSeFFDIk0Yr2/9y
         Ml0w==
X-Gm-Message-State: APjAAAVabif/xNUtOw2y0v5nvinzzgbOWtytU1mVUszg9JnvQWZPUpqS
        11kwJaFSrP2RxX7FuPM5vsl6+w==
X-Google-Smtp-Source: APXvYqwvaXlp6b1DQ1WYsBCoXgCiwBLcdRnVtsteeU9PJmkuSPc3tVzV6FjEbFGZ3v7o3Ms37XPL5A==
X-Received: by 2002:a17:90a:8a0c:: with SMTP id w12mr14399932pjn.61.1580133143553;
        Mon, 27 Jan 2020 05:52:23 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a10sm15682348pjq.8.2020.01.27.05.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:52:23 -0800 (PST)
Date:   Mon, 27 Jan 2020 05:52:15 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ron Diskin <rondi@mellanox.com>
Cc:     David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 1/6] json_print: Introduce
 print_#type_name_value
Message-ID: <20200127055215.65e44719@hermes.lan>
In-Reply-To: <1579775551-22659-2-git-send-email-rondi@mellanox.com>
References: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
        <1579775551-22659-2-git-send-email-rondi@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 12:32:26 +0200
Ron Diskin <rondi@mellanox.com> wrote:

> Until now print_#type functions supported printing constant names and
> unknown (variable) values only.
> Add functions to allow printing when the name is also sent to the
> function as a variable.
> 
> Signed-off-by: Ron Diskin <rondi@mellanox.com>
> Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Series applied.
I fixed one style complaint from checkpatch by removing semi-colon
in macro.

WARNING: macros should not use a trailing semicolon
#80: FILE: include/json_print.h:75:
+#define _PRINT_NAME_VALUE_FUNC(type_name, type, format_char)		  \
+	void print_##type_name##_name_value(const char *name, type value); \
+


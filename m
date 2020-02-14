Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C5815E9E3
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392191AbgBNQNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:13:35 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:41385 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392179AbgBNQNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:13:33 -0500
Received: by mail-pg1-f175.google.com with SMTP id 70so5171534pgf.8
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 08:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=niA/4YNfZ9q8PjZQVMpXc6FwzAHWxTaU8Q04PlMxL74=;
        b=qeZvl0BnGgivg3WzyEii9bLiefbIRFXrkLS0I29IPj8IsBiIO0jBtAdwK+J2ZbQrqc
         v6IIvDu0ZBQKoSCmnJpZ/OQY3ZmAZMJLllmey81C8lSLRxbG8vAPnEEE35A+1OVAzq+j
         rfY4oFvNLFg9ZhN+GS6mBKtjR4FbWUCOJnljpG2F5Ks672deer3jr6bNAIFlUwPssViE
         Pe5YC4x91zoy6sT3DzQwroWwIZl1rnoAuRm4qQfh/xlKKCQ3Cjz9p9NpmvukIlsK67p6
         hBd8OdzpMtaQO3X3r0FTSV2FwdZXz6hS2BgMZi7Ks/waWxEcBDP48G5Lx9qKNIBKbjwK
         XF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=niA/4YNfZ9q8PjZQVMpXc6FwzAHWxTaU8Q04PlMxL74=;
        b=FzqOOaBv6reudYGgd8xT3qF3E0PiqpLaslvVi4//2auMp70pjDfDvrWWcvYz+NWZy0
         4iMHLjIgoTyp/dJGGWIi6sX+ES/z7mhjFQlwgI2uXycYyTcl6yt1NK7Kz8CQ2UVuPIdi
         I2nJYpkYhPhxNym5No36XVRIi2jO262C1kOA0vJfrso9qSAy8tYAJ2A5OZ57gKlx3Djy
         E3W5FAxr89GuA+tsd6qtShQsq3O7QaxKb3SzUYU0sa07nP5Q/WmUGgobPBA5eiY8BeAe
         hFC6a52S0CVWVXFwI6Iji2xuV4QuHAiMy/U8r1IA7Vx4lLr27iiSK0nKfZCYxY+LHd4f
         j9Bg==
X-Gm-Message-State: APjAAAWMXz8PM9OdQF2OPI/IdLefPer925nx4uax7rT+4s/JOIo4S2x2
        zsnldYvCDrSwdKKLaGQpn0wPD2aVNj8=
X-Google-Smtp-Source: APXvYqxVdietMtBduG5sbjLs1CY5oVtyGn+ggudPUeWzV98vzeldJwAAkIT1WrUnJsb9y/ZMVg/uzQ==
X-Received: by 2002:a63:a707:: with SMTP id d7mr4127439pgf.390.1581696812736;
        Fri, 14 Feb 2020 08:13:32 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id gx18sm7403945pjb.8.2020.02.14.08.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 08:13:32 -0800 (PST)
Date:   Fri, 14 Feb 2020 08:13:24 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options
 support for erspan metadata
Message-ID: <20200214081324.48dc2090@hermes.lan>
In-Reply-To: <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
        <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
        <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
        <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Feb 2020 18:30:47 +0800
Xin Long <lucien.xin@gmail.com> wrote:

> +
> +	open_json_array(PRINT_JSON, name);
> +	open_json_object(NULL);
> +	print_uint(PRINT_JSON, "ver", NULL, ver);
> +	print_uint(PRINT_JSON, "index", NULL, idx);
> +	print_uint(PRINT_JSON, "dir", NULL, dir);
> +	print_uint(PRINT_JSON, "hwid", NULL, hwid);
> +	close_json_object();
> +	close_json_array(PRINT_JSON, name);
> +
> +	print_nl();
> +	print_string(PRINT_FP, name, "\t%s ", name);
> +	sprintf(strbuf, "%02x:%08x:%02x:%02x", ver, idx, dir, hwid);
> +	print_string(PRINT_FP, NULL, "%s ", strbuf);
> +}

Instead of having two sets of prints, is it possible to do this
	print_nl();
	print_string(PRINT_FP, NULL, "\t", NULL);

	open_json_array(PRINT_ANY, name);
	open_json_object(NULL);
	print_0xhex(PRINT_ANY, "ver", " %02x", ver);
	print_0xhex(PRINT_ANY, "idx", ":%08x", idx);
	print_0xhex(PRINT_ANY, "dir", ":%02x", dir);
	print_0xhex(PRINT_ANY, "hwid", ":%02x", hwid)
	close_json_object();
	close_json_array(PRINT_ANY, " ");

Also, you seem to not hear the request to not use opaque hex values
in the iproute2 interface. The version, index, etc should be distinct
parameter values not a hex string.

I think this still needs more work before merging.

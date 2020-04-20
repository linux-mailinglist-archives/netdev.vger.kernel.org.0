Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F501B0458
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 10:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgDTI1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 04:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgDTI1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 04:27:03 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF96C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 01:27:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j1so5560276wrt.1
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 01:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wkEZmDKPCZqLa+I7uPirPFiS5mbiwVYc3uRVerQjM/Y=;
        b=hjvbl8XYgTxLME9BGU7smyZ7khRszvrb6dX3Ryb89UbCXhMncwAvXaAUVsqX5IBsMG
         /XJ0Q4xpByADyUsRWUNrfs4d22vUO7D4c1mB4PtBkfG8MaCEpHexd4HOCL09KLtpvJdP
         uDZLtla9ZjOuYnFEI3UMt/6VA3WIYPt35+aHRzPFMALONTpE7ie0PMNYxKk/i7r5PDWp
         pj5TOVKkZTtrqGn7b9lJ3Q/8OHt0uwP+NKg66cvp2y1S1/CU/aP1cKPys5cXS2sJyjvA
         CcuNK0d9B6U8Co9gNV+vJExJHn7Yep2Yj62w56BH2cYZWnQUYZckCJZhVnfs+4W4rjtV
         nA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wkEZmDKPCZqLa+I7uPirPFiS5mbiwVYc3uRVerQjM/Y=;
        b=JNtztCSCAB936UuhfM6MAC1R8zAfrky3FLl3NUMBW+pZylpTIRVuqik0ZmE8Sb40Zy
         2211zftxxQIq/rtMeHnf9oO1QiQyfMY9amjPyso45IWFO/mO/XgX7Fwn/Nz/TtjcNVe+
         teICbIOsljHk2L2A5djeupkErpnKycc3/JMwhRvu/YHwYO6+kU+R9NsRYrWLRt/WnjPq
         7iumIl6gLgxU7wHx7DpvP9pbL7LuddQMNGi1QzjRj+pA8DVB3HpX+BwZrRFmNBOzSJLz
         OJWFiCddqfOJl8LN6wNnn978ydmQU7Ap9MPo7dGKJqZO5zPHjzKg9kPKGHFFESh+1hwk
         nTIg==
X-Gm-Message-State: AGi0PuZISxqJZITIjksvjeeHUZN1Jk1nzkW2a2+4dv8oF/Tic1ss3h35
        Y0AT7IIG4Bu2DK3eWAqG/C503w==
X-Google-Smtp-Source: APiQypK0fFftccsHGnmezQIyKk6jPNNWfDtYkenMG3g6vtHtAaoP/aM6TTb4Eisu3T9jYgTPOx4Z4Q==
X-Received: by 2002:a05:6000:1007:: with SMTP id a7mr16642104wrx.279.1587371222065;
        Mon, 20 Apr 2020 01:27:02 -0700 (PDT)
Received: from [192.168.1.10] ([194.35.116.120])
        by smtp.gmail.com with ESMTPSA id t16sm257756wrb.8.2020.04.20.01.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 01:27:01 -0700 (PDT)
Subject: Re: [PATCH] tools/bpf/bpftool: Remove duplicate headers
To:     jagdsh.linux@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, kuba@kernel.org,
        jolsa@kernel.org, toke@redhat.com,
        Paul Chaigno <paul@isovalent.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1587274757-14101-1-git-send-email-jagdsh.linux@gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <5c63c379-9b91-c134-1c23-18133ac0f88c@isovalent.com>
Date:   Mon, 20 Apr 2020 09:27:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587274757-14101-1-git-send-email-jagdsh.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-19 11:09 UTC+0530 ~ jagdsh.linux@gmail.com
> From: Jagadeesh Pagadala <jagdsh.linux@gmail.com>
> 
> Code cleanup: Remove duplicate headers which are included twice.
> 
> Signed-off-by: Jagadeesh Pagadala <jagdsh.linux@gmail.com>

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thank you!


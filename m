Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F3F148ADD
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 16:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387948AbgAXPEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 10:04:47 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55687 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387432AbgAXPEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 10:04:47 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so1940353wmj.5
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 07:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t0us1egyJN/IQkR4VwHHKMwizOggcRQJO2AHleYRg4U=;
        b=VXUC50YGvdOkI+i639fqtKHyYgh+EhrZ6qiXdyoqWD9PY4A9kZBIhxnWjedQiBikrA
         TICGV/XdziUTwNZ7tgje8Rn+emnboi0+m1PbJOxnH7tK9jnEGJPUSLc2McTsf8UFfeqa
         +x50yTz6a5RLNloQVIkfK68XbhZunEsI/wA6e6VcM2hOc+obwngzFVwc7AFYOIDQzRdr
         FSL8QxjPdgGQwkjGDac26sv4cYXQd7tyIbunypIEZx6H8MKEFoICnYZsSBnQovntzTrU
         ogcBbyJXN0iKXii++BeeAvkyjq0NcGS8wck3jkQyXxZMHbwMX9GwOJCiDHBeApTSzpwv
         41bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t0us1egyJN/IQkR4VwHHKMwizOggcRQJO2AHleYRg4U=;
        b=UyyaOcSxAO56k8yahX1mCA0NRBDeIugVttFbWvpgcqEEUO1uzSWitK9THmKb3Aqb1P
         YPdS0440GVxKRArjekNkGIkDzupEkIuJdhTTUQSj6mtJ2K/5efYvAAL/vxy1uFF3Ay9v
         bfgAib9jTafF8fEgJlaD3XuX2TQXi1EyiALNKmNMEp6oce+6iLowwRblLn1YMoOMOvwD
         0GrDx45cQDyaWj3ubkztOd8/cy10N1s3nKgCBKoLv9RFNldApSTs5dSm9j8YggG/OcfR
         AM9zEYuyivxykZm1nhfsi2ZnZQ/tp7Pp5HJbyp/pvn0Y8fL2siQ4TNVuRBEro95GR7e/
         1VQg==
X-Gm-Message-State: APjAAAXWwjZGUVSG+cIei8LM/TZpCzV30rH18LN2w2RhZE3gQIErwBEM
        Mo+nf7pUS00PZU+I3tANKhoXvg==
X-Google-Smtp-Source: APXvYqxkNQAimdFidRnq/I5M3hAhKg+ntnP/lAawmQApi9NVOU/R8jyKayFvAvsK3gNZt+6PfZhnbg==
X-Received: by 2002:a1c:6485:: with SMTP id y127mr3793720wmb.11.1579878285610;
        Fri, 24 Jan 2020 07:04:45 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l17sm7702462wro.77.2020.01.24.07.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 07:04:45 -0800 (PST)
Date:   Fri, 24 Jan 2020 16:04:44 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 06/14] mlxsw: reg: Add max_shaper_bs to QoS ETS
 Element Configuration
Message-ID: <20200124150444.GD2254@nanopsycho.orion>
References: <20200124132318.712354-1-idosch@idosch.org>
 <20200124132318.712354-7-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124132318.712354-7-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 24, 2020 at 02:23:10PM CET, idosch@idosch.org wrote:
>From: Petr Machata <petrm@mellanox.com>
>
>The QEEC register configures scheduling elements. One of the bits of
>configuration is the burst size to use for the shaper installed on the
>element. Add the necessary fields to support this configuration.
>
>Signed-off-by: Petr Machata <petrm@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35ED8509F7
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 13:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfFXLmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 07:42:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34251 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfFXLmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 07:42:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so13569354wrl.1
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 04:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ajOyvaaRppirqLsQvdocnjF/FhWJzHoGr/B7GuKLliI=;
        b=NhnmAtXwu+DZDkos1uOMeOwX11gLlTcZoPTyJPx820C0KbLaCyAaNrU6MLfBooUtaK
         ovPsl1hKlJexyS3nZbdSwlCE6AkBkn+gezP2rzbSfDKaKNjd0Y+HX6nYWzfXW0YGQsrA
         t/n/kBQAVlKJQwQoMyaHJHtAtPtL6Fx6/uRuiC5zZHQMxamwuITOsBiuL4/76VlIvvSV
         wKlnq+GumsQQgTpgMmxfzfrsbhCmc9VsxKA/R+yFB6CizMs+XEyOqCB9rOt/jwOSHU2b
         Twvld0CVmKGAbUiS/ZxnXf5I0bDPQ2z6tIbp8KztQMESB+A1EQdQthmWxJ6CiSGA+S+/
         ZFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ajOyvaaRppirqLsQvdocnjF/FhWJzHoGr/B7GuKLliI=;
        b=g9XlgyJtvFdMpRdiRllJgHq37ElbcroQQb3jGAVprMhhZ5XIdY68Sl+5b/nIfkLrka
         79bdH8yzZKNZ+IIvg0EFuCN96zWNDwBqUIBt12lIioq/a65ArcOTZPT/4awHwDyH5Zpp
         N857kZ0coXpXXIsFUq932eNlYSj7or4AjRaOGKVXPDJV5z+LJvWmntJRhxKsfnGwan0M
         LwF5yORSyOdfCXFHHSYTkBvfxhvt9D2hBAIf/FP+WLdDLFJ9+mZtF3er35OMsJROsdSo
         L+ITK5MgAlW9VTPB3ZxnCoN132wkFPEVLOkh2Ot/1bsqxmcE6yocTMt/hBEUAzLVnf/P
         BHSA==
X-Gm-Message-State: APjAAAVUDt50l8BwyGbtwK/VFQ22pG51KxoletOVSeK8D41XfCYOQFrM
        +rYUZR8f5Av/oemxyslh/aXpvUqi+so=
X-Google-Smtp-Source: APXvYqz0ECCmF2EI8n+pV4z4SGCMjT4lrKKo+42z0YrmT/vRIFsC1855azwBXtSZsmqhzf6SQC20sg==
X-Received: by 2002:adf:cc85:: with SMTP id p5mr47064522wrj.47.1561376522103;
        Mon, 24 Jun 2019 04:42:02 -0700 (PDT)
Received: from localhost (ip-89-176-222-26.net.upcbroadband.cz. [89.176.222.26])
        by smtp.gmail.com with ESMTPSA id q193sm8750048wme.8.2019.06.24.04.42.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 04:42:01 -0700 (PDT)
Date:   Mon, 24 Jun 2019 13:42:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        vadimp@mellanox.com, andrew@lunn.ch, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 3/3] mlxsw: core: Add support for negative
 temperature readout
Message-ID: <20190624114201.GB5167@nanopsycho>
References: <20190624103203.22090-1-idosch@idosch.org>
 <20190624103203.22090-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624103203.22090-4-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 24, 2019 at 12:32:03PM CEST, idosch@idosch.org wrote:
>From: Vadim Pasternak <vadimp@mellanox.com>
>
>Extend macros MLXSW_REG_MTMP_TEMP_TO_MC() to allow support of negative
>temperature readout, since chip and others thermal components are
>capable of operating within the negative temperature.
>With no such support negative temperature will be consider as very high
>temperature and it will cause wrong readout and thermal shutdown.
>For negative values 2`s complement is used.
>Tested in chamber.
>Example of chip ambient temperature readout with chamber temperature:
>-10 Celsius:
>temp1:             -6.0C  (highest =  -5.0C)
>-5 Celsius:
>temp1:             -1.0C  (highest =  -1.0C)
>
>v2 (Andrew Lunn):
>* Replace '%u' with '%d' in mlxsw_hwmon_module_temp_show()
>
>Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

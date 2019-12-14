Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF5C611EFF5
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 03:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLNCQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 21:16:00 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46827 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfLNCQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 21:16:00 -0500
Received: by mail-lf1-f68.google.com with SMTP id f15so601700lfl.13
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 18:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0t+Co+YM2Vcx/HBNqKjw5nNGg/a0Im73bSXvzLiuJZ8=;
        b=E2TMRWWb8iDGTkjYxqVo5yHuaoTwmFsQwsHm+1/X5tAHb/w14PodXR4JEcKbciWUbb
         vvLKbHewbIlxnYN+OMEsds3EaCJuSz8rmxOFXsksPtTo62HkVnkV+s9W32BCaYqXglOA
         /PAyrQbxS4hP++czH4USuI6PUSWxfsoiMGSIDuPzjhF5iAuldo2FC+adErdw2VsT0Iif
         DBs4raudzhvvxP9mcvGUUo1YfEGfhtCrMPa9JmSLSnlPymbDCp3NPvXoKP1Nl2XLYX8y
         0HOGjO3FYogxinmpeVEQKdLEjEwLfp7iWi1OmaJbLsgOZ6mXnQZoxrO/LF8SZdTa2csp
         c+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0t+Co+YM2Vcx/HBNqKjw5nNGg/a0Im73bSXvzLiuJZ8=;
        b=KHI2RwUehyUQpP6O0uvrEsVlVDBGA92SkxIpLJAi/o/ZXasFPeCdSKs6z0lT+EgfM6
         ZEZ4oyMeOywxp3hQa9JTvQ97W6v8M/2Q7zNNPsZ84i5oSTrGTBTFsiL3EU0da0rT+gfK
         sbxzMlpvvQdIWF7gOz6/x3a4q+tprGcWbL+Jcmr+4QV4oPsqRgFeYbKXY42Bsd7IbeHh
         XY81ury9taEJ74YHeSgrviyYrAJsDmsVAsliJMetmljYcATfndSCeydL947qlItUcEy9
         YDsZZxZD8qvE1kABqgaYCyVUZ6ANeqzuknDtWNoFl3dCAfJUi/DF+mTmBB6yUJE2Zc83
         vRmg==
X-Gm-Message-State: APjAAAUcQe+IgZIwLjmu5WSwXcd7Ad9kCDYuLaXGJrBnRu2BHyDd8v/t
        ShmkJfFU0L4xAS8FKOkUl9e8Ck/1gzY=
X-Google-Smtp-Source: APXvYqwOJ++Svs7bR7sotIk75IzIOFWlmXAlrF9jz5LDoMKSLjDK3qVcLnu7a/k+xkZ/0Rn1ayBLJw==
X-Received: by 2002:a19:8a41:: with SMTP id m62mr10596570lfd.5.1576289756922;
        Fri, 13 Dec 2019 18:15:56 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y7sm5600560ljn.31.2019.12.13.18.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 18:15:56 -0800 (PST)
Date:   Fri, 13 Dec 2019 18:15:49 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: Re: [PATCH net-next] Revert "nfp: abm: fix memory leak in
 nfp_abm_u32_knode_replace"
Message-ID: <20191213181549.0357de09@cakuba.netronome.com>
In-Reply-To: <20191210182032.24077-1-jakub.kicinski@netronome.com>
References: <20191210182032.24077-1-jakub.kicinski@netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 10:20:32 -0800, Jakub Kicinski wrote:
> This reverts commit 78beef629fd9 ("nfp: abm: fix memory leak in
> nfp_abm_u32_knode_replace").
> 
> The quoted commit does not fix anything and resulted in a bogus
> CVE-2019-19076.
> 
> If match is NULL then it is known there is no matching entry in
> list, hence, calling nfp_abm_u32_knode_delete() is pointless.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: John Hurley <john.hurley@netronome.com>

Applied.

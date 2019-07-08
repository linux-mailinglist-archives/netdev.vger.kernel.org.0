Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3225B620BD
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731933AbfGHOog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:44:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51298 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbfGHOog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 10:44:36 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so16111011wma.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 07:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GoufARafJJ5eWxlmMdnB1kEeJwHzx/Dew+UiRosAHn8=;
        b=CcXON/0mfenBJfYjFz3c+LdqG6Wp58ROXhxuayb2Vu9drc4DF0pfLY1j0QZ0nig0Pt
         Er3f+gfmze51n+fVCqgIDgZIxM35jBYgzySzLqP579UxWv1ZkhlFN95ddBYeAM3baIxI
         SepBtNut7+QblNzCWAoGiNX3tHqberKxRj7IigeDS3kokLHbUv0fB6LogbvApR6NB9MU
         g95oPxJbyxFcgZhYsVEkzH1vAoLXnvJiTYM1HKiHAAMmh57IlY+w8VWnBkfeMS+F7Mbp
         JAxKuzveR0LutclsGAhR5hhXx+U90t4BdnrDwBJo8Bi/tBViMzOXvFxPGpEmhTSsYfHs
         /ZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GoufARafJJ5eWxlmMdnB1kEeJwHzx/Dew+UiRosAHn8=;
        b=ZATKMvxIhAl3yl/76HxwG+Hzvggex/ybUzj5hkLsTf89HDMdNfHFtkyyrxRD/L6DsS
         Tc237dmQoNeFyzMesjWPczi9E8yEp/hGH2ghcVmo1G4CACH5qGzOad8y8mEvTBiEndut
         rwKBbz8bl0hyQlN5M8iYvw3sWEr4VJQebwE0EnLvLvt876VIdG2CCyjt9s5dQ7bah3ru
         vdFHwmyYvITU7Q9EmYGrhZPzDkQ5p0D21dsqU57kifLObTAUzs+UM78JEl61BpS4AHv7
         ELc6/Yh0jSGxL/KINLuXiA92geb/Kf6tvW8rgkb5ornpoHPjp4SdygWJNgaQWHMOhuRw
         A3eQ==
X-Gm-Message-State: APjAAAXElNJF0+9HXfgCAMwsQrAjNBGNvZ/lyVtsHTUOStVLyaU4I478
        /gJGANEJPWwKV9QTquKEc6GGMw==
X-Google-Smtp-Source: APXvYqwDY3Gj7XMeODr0JzzWpYwHVntV4vbFine9oiM4mKSOwtq4di7St3Bo5MER7Wi1x9Ma7alyZA==
X-Received: by 2002:a1c:6643:: with SMTP id a64mr17814298wmc.154.1562597074632;
        Mon, 08 Jul 2019 07:44:34 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id a84sm18397726wmf.29.2019.07.08.07.44.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 07:44:34 -0700 (PDT)
Date:   Mon, 8 Jul 2019 16:44:32 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v5 2/5] devlink: Return physical port fields
 only for applicable port flavours
Message-ID: <20190708144432.GM2201@nanopsycho>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190708041549.56601-1-parav@mellanox.com>
 <20190708041549.56601-3-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708041549.56601-3-parav@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jul 08, 2019 at 06:15:46AM CEST, parav@mellanox.com wrote:
>Physical port number and split group fields are applicable only to
>physical port flavours such as PHYSICAL, CPU and DSA.
>Hence limit returning those values in netlink response to such port
>flavours.
>
>Signed-off-by: Parav Pandit <parav@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

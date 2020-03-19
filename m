Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6988218C211
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 22:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgCSVIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 17:08:30 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:39220 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCSVIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 17:08:30 -0400
Received: by mail-qv1-f67.google.com with SMTP id v38so1864373qvf.6
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 14:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=1QN2ZMWv2qRl+OA7zOrRwqP7eJXFEdbJUyZMzX/5QVM=;
        b=JLQWqBaLHlcsTqYocYzmrFvA3aW5vJsZvZ1DRF7wITYZrlEH5ii/WyPBT06LKTEO4R
         CL/UKtQ4mT9B/ezu1L2FzXv+BUZQBG4H6wivrSK+fxiNJNNZt8kQeknSUWlIaqzfSjYT
         1TIHL89VHzhPYfc2buemdpfs2D1HB01agwt0LdfQRnUQDMcdFkZSpsJ1pppppoVHW0oI
         2cTR8IWku27Aie69IjgU0mQu56R2J2TUGZgC6637EuAwEtjNUi5S/Um54KiQAmpaojCt
         jMo4xS8zrlVseSMCBT4BfaxIap3uNyTem9U7IMv+wJqOGuLvHY1W4+fkMDD+teSer/4u
         WKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=1QN2ZMWv2qRl+OA7zOrRwqP7eJXFEdbJUyZMzX/5QVM=;
        b=RzKE+V/BNWpDVCZJ4MJ8b+L6bK3esAwvJEi5ZkAPeLj9xOU96iPjsaHrrLuhXexz0y
         2j9pE2tsdKNicBr/+Q/NjAXarwuLTR8k07YPeSxkED2d1UUAi9n8PRKxNjJjJALU4ZrY
         ybMhDoxSF2dCSmvAMx5/mpzdr73Zm4CpeL7FSJagufOu2JojQE5be5a+UxOsTuI7omYJ
         Ji0h4Rb1+SSXrCQDTaQer5nASAkOh5oCn9OjpZyvkkyTN51o+zAxuKV859kZy+JX819n
         vtkTw8aC3EDTGT3FZgFhZnvpHbp+7kQjr4OSoxiC6eKAQV1RzKFjFF3AqL11hXAMA53i
         Yddw==
X-Gm-Message-State: ANhLgQ0SZ6uZgnXMHtQqdyZpu6pdncwL4UbbIRZ1X0m/qF3wzCY9qirp
        LS7WXqqUDMV+0Juu25sK/9M=
X-Google-Smtp-Source: ADFU+vuQskxR7uvL0PBGppgHJPfLFZX0xG6obZnryNed4REpSBMrRzpebnJznmC/aGlRZW9HyNcPYA==
X-Received: by 2002:ad4:5429:: with SMTP id g9mr4903736qvt.134.1584652107300;
        Thu, 19 Mar 2020 14:08:27 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id m65sm2467686qke.109.2020.03.19.14.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 14:08:26 -0700 (PDT)
Date:   Thu, 19 Mar 2020 17:08:25 -0400
Message-ID: <20200319170825.GB3468034@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: Avoid error message for
 unknown PHY mode on disabled ports
In-Reply-To: <20200319201210.22824-1-olteanv@gmail.com>
References: <20200319201210.22824-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Mar 2020 22:12:10 +0200, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When sja1105_init_mii_settings iterates over the port list, it prints
> this message for disabled ports, because they don't have a valid
> phy-mode:
> 
> [    4.778702] sja1105 spi2.0: Unsupported PHY mode unknown!
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Suggested-by: Vivien Didelot <vivien.didelot@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F4812FF8
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfECOSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:18:38 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36025 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbfECOSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 10:18:38 -0400
Received: by mail-qt1-f196.google.com with SMTP id c35so6859802qtk.3
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 07:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=rb8Mx+g4Pod9+vQCEzf0V/B1ONsCIV369znyJ5DEqnM=;
        b=oKBQ9jJzg/1QNyhIMfDQ0BKSV7R2j4v0HsVV6HFnWsbXSCC9imI3hM8GLRog0agU6n
         KJoqBwECa2Uzf271t2dR/OP5pBFHwsaJOxqGapXcFOJ+ENqyHmVfrdxfGNV56k8agNxv
         SqYaKc4lNGJAE7jdvG981EF/SZWeI+2bbSzXxZ1CspJp/GvkMVmLXyHt1HXTtKQYqBUC
         FnfuYs7oHO4AHOgy7FXXQTNS8zvuTZ7J+MldpyBzLm4v4YdSBtgTEx+pqgs1b343I/c4
         8hOSxrBbJfyqVztQLH1lHtAPXVm9239ybObqGWBD6RVVwhx6Etr7IpTxr1kTR0KDhi26
         zWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=rb8Mx+g4Pod9+vQCEzf0V/B1ONsCIV369znyJ5DEqnM=;
        b=D0fzQtXsDmdP/HOtxIhcCl+NOusvcNO5DRBUbRO1eQ+F47wji/YP1XIKKtBYbdUMs4
         EZB0ZShIaY8IGIU+mR0E5GioGHmR/DkAweaQCKrC5Zaw5NHVHnkuD+koTwJkXNXRDEON
         QJGGpLU0146Qq8Y3bAwQDP6zQuKEL+ep3UDCtH21zZgvQbBL36XSB/cQCU3vLSTM+Xv2
         MbI/M4kZWlwDleEOUOhXHCQ6D1gsJIFMQ6JihYpaR+SvZ4oTUCpQvfUXHI6wRJP3eOEk
         FGRAxgr+7PBA4+METj0pvTUpuIBiC4SHFNGbZcq8mUqK23cQpaJ0i5E1tpZKII3Lt39A
         hBjA==
X-Gm-Message-State: APjAAAVM0JccqxBOkb2lTlqDH248q9oadFeZwowIVpHHpAS1Y/bn8ZAb
        jo7takaz+ktCBLXqLEkRXJI=
X-Google-Smtp-Source: APXvYqwXn/2c1/1fTNOlJEBJAMW7LbQNICcT5Hf6/SUVvBDDrguiKR5/jT4RdPb/9G8vGuVwDy1+KQ==
X-Received: by 2002:ac8:53d1:: with SMTP id c17mr8575016qtq.340.1556893117416;
        Fri, 03 May 2019 07:18:37 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z85sm1399954qka.18.2019.05.03.07.18.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 07:18:36 -0700 (PDT)
Date:   Fri, 3 May 2019 10:18:35 -0400
Message-ID: <20190503101835.GD25090@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 2/2] net: dsa :mv88e6xxx: Disable unused ports
In-Reply-To: <20190430220831.19505-3-andrew@lunn.ch>
References: <20190430220831.19505-1-andrew@lunn.ch>
 <20190430220831.19505-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 May 2019 00:08:31 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> If the NO_CPU strap is set, the switch starts in 'dumb hub' mode, with
> all ports enable. Ports which are then actively used are reconfigured
> as required when the driver starts. However unused ports are left
> alone. Change this to disable them, and turn off any SERDES
> interface. This could save some power and so reduce the temperature a
> bit.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E397DE59C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 09:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfJUH5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 03:57:44 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35009 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfJUH5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 03:57:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id 14so5038694wmu.0
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 00:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5RdNTwgBCdZcCZ1j8Z15ni4PJSiSusKClMun4ER4Tgs=;
        b=mQXlstLVlWiDctiPlciVOrdqPyKP5kAfQXuoH0OIifk86r2ksskFSm+4fSIhUUFjru
         DoJ60PWqGfr2GmtbcxpVE0D1nhClmDg8jr119kHdWld6ulResnXKd5csnnhsU75fxT3k
         p4rPw2TQjuxu7JEv7fkAhHxydhk/T7TLXWoGboM8iIEk1XCN7visRqTmYe6yR14nSo6M
         5L9Em4t4BxhiMPcdle3YNw3DG/CV+FbzM1mwjus131uDrZlA+mr+QSFZQhFnco4vT+Sd
         yA4XRzyfLxpQadpE6PXubHZz0s+5VsJyz23qsqVTEoItRXknp4IIw4KTRnHHsVZJZ12G
         8xQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5RdNTwgBCdZcCZ1j8Z15ni4PJSiSusKClMun4ER4Tgs=;
        b=Jj4rg7RLR6RaVesHSWqifKllLje540KLVs1GLYJwgpqCBiwUSUVdXXhGg/GjkvQMu5
         yGTpLuwnL6JCL+R0ZtoDZBhVHdQkSNNE4KNPZFg8r8cHwhX/p306MyM00F4Vt9fyX0mR
         gHXgAOwwk1qF53Ij9xlxKPfFqxGFpptrS/ppe5Q8rAOs3ETRGZ2crb714VJegLdOdNyp
         8yqVpS1JLBl81MfHQYZp4m9hpPFZuPCQxDWTUSzBA+NCSfjVwss76C2oeEC8GPwd5iNy
         7xLrpHYEOryIHDf3wtO+7VTpN6jIDuJFJr1DlNJXPnc/7gUXARFfjX83QUT24bP54fJM
         eGpA==
X-Gm-Message-State: APjAAAVmZET3DqQkJL0BrSC7B59hUshv8fVEdpXB4m975O5ZomwoPbBU
        7DoeCQcF6K0X7WlcYc1A+S96ng==
X-Google-Smtp-Source: APXvYqx2nPNGnpXiwcOXlzcrSGhlCcdVAVN7Vb8ubE62RwPCkohJvRxmrs5GSA088K1tO/ufM21Wsw==
X-Received: by 2002:a1c:1f4b:: with SMTP id f72mr8058789wmf.22.1571644662586;
        Mon, 21 Oct 2019 00:57:42 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id s12sm14766827wra.82.2019.10.21.00.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 00:57:41 -0700 (PDT)
Date:   Mon, 21 Oct 2019 09:57:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191021075741.GQ2185@nanopsycho>
References: <20191019185201.24980-1-andrew@lunn.ch>
 <20191019185201.24980-3-andrew@lunn.ch>
 <20191019191656.GL2185@nanopsycho>
 <20191019192750.GB25148@lunn.ch>
 <20191019210202.GN2185@nanopsycho>
 <20191019211234.GH25148@lunn.ch>
 <20191020055459.GO2185@nanopsycho>
 <20191020060246.GP2185@nanopsycho>
 <20191020173104.GB3080@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020173104.GB3080@lunn.ch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Oct 20, 2019 at 07:31:04PM CEST, andrew@lunn.ch wrote:
>On Sun, Oct 20, 2019 at 08:02:46AM +0200, Jiri Pirko wrote:
>> Sun, Oct 20, 2019 at 07:54:59AM CEST, jiri@resnulli.us wrote:
>> >Sat, Oct 19, 2019 at 11:12:34PM CEST, andrew@lunn.ch wrote:
>> >>> Could you please follow the rest of the existing params?
>> >>
>> >>Why are params special? Devlink resources can and do have upper case
>> >>characters. So we get into inconsistencies within devlink,
>> >>particularly if there is a link between a parameter and a resources.
>> >
>> >Well, only for netdevsim. Spectrum*.c resources follow the same format.
>> >I believe that the same format should apply on resources as well.
>> >
>> 
>> Plus reporters, dpipes follow the same format too. I'm going to send
>> patches to enforce the format there too.
>
>Hi Jiri
>
>I'm pretty much against this. This appears to be arbitrary. There is
>no technical reason, other than most users so far have kept to lower
>case. But in general, the kernel does not impose such restrictions.
>
>Ethtool statistics are mixed case.
>Interface names are mixed case.
>/dev devices are mixed case.
>Namespaces are mixed case.
>All HWMON properties and names are mixed case.
>Interrupt names are mixed case.
>IIO names are mixed case.
>etc.
>
>Apart from the FAT filesystem, can you think of any places in the
>kernel which enforce lower case? And if so, why does it impose lower
>case?

Okay. As you wish. I will change the checker so you can have this as
"ATU_hash".

>
>       Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5E6DFD6D
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 08:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbfJVF7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 01:59:50 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:43791 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731015AbfJVF7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 01:59:50 -0400
Received: by mail-wr1-f48.google.com with SMTP id c2so11243532wrr.10
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 22:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q3GxIN2kgEdujPtukFVar+zJGEYVs/KXwGWhbJx+uXA=;
        b=bZDJ/hmAV7tuk5OZSuSiWxKmir0rJu5i1mwwtB5iMyw9YaKZilnm2O3i4lDbbLJ92M
         YZugqW2Q+VNhCS2WodI1ZJLWJdkGbvxUyqyo35P4AyOKVIU8ohDGADww3GqfkTRlq3sc
         LvR1K2s7QpewRuK7Efq3yX1CQTF7Wt/0MUb4imvC9IjK2BNGFJfU57/kjsa00lb7q7Os
         p23xIS/99/dfSA853Iq7UOFIhR0XkvFmMICZ1bLTDm4lf+V7Gdk6MAWfTaCIN06OZQs1
         WhEZaX5+/JS3kVvvCdJQwNyRPFLugQRAOSNzcqGv7BRAzQV2P76wSg0rDU773SAZTUzZ
         MCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q3GxIN2kgEdujPtukFVar+zJGEYVs/KXwGWhbJx+uXA=;
        b=FI4Xr/qlrjQCsYtIuJgDNGg3K3YV2QoqIiwfOUVV2W1yw2Sjo/WF1Ba7x973JVyvKY
         W2bRfJ8no7sDJ3i/+MQJvRSQqprGRSiNCZ5O2QWd+eYj+97QHmzwYcNdh2qLCPz2G3qx
         APYMaMaPYoX1Po7wMBbHqySeYEcpY2TFN+Wapl5UR7/Ojvd6MA3LfUzOmb8BBK9JVpAD
         txsFXLFfpxWMtfzKBCBF6BadNGcvxH6x+Gaczs0PWsY9/qUJv4/8FrgSWBk8MBv+oRc8
         r18q7ljMw0jTP4prkdHAxMpU+9T/y9d+WOf7AqoLavZ+orQ0gPZDVNSDzYlCvADEQ65o
         hjuw==
X-Gm-Message-State: APjAAAXTzbOBa0edt0mzU9ea9Ympm4yRnZalUCkO+paMVYVGKVwQOki8
        EW/ibQOSa+WPQhAHz2cLQelCew==
X-Google-Smtp-Source: APXvYqwQh9nGbuFiE5AOXBHU37quELf2SESAD1E7Sv77fo83vPMpA2gcyCmZsPNke2h8gwFrkT1tLw==
X-Received: by 2002:a5d:44c6:: with SMTP id z6mr1612699wrr.313.1571723986631;
        Mon, 21 Oct 2019 22:59:46 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id a2sm4413219wrv.39.2019.10.21.22.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 22:59:46 -0700 (PDT)
Date:   Tue, 22 Oct 2019 07:59:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, andrew@lunn.ch, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 3/3] devlink: add format requirement for
 devlink object names
Message-ID: <20191022055945.GZ2185@nanopsycho>
References: <20191021142613.26657-1-jiri@resnulli.us>
 <20191021142613.26657-4-jiri@resnulli.us>
 <60dc428e-679e-fb16-38c2-82900c9013de@gmail.com>
 <20191021155630.GY2185@nanopsycho>
 <0f165d72-bb54-f1cb-aaf7-c8a20d15ee49@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f165d72-bb54-f1cb-aaf7-c8a20d15ee49@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 21, 2019 at 06:11:33PM CEST, dsahern@gmail.com wrote:
>On 10/21/19 9:56 AM, Jiri Pirko wrote:
>> 
>> I forgot to update the desc. Uppercase chars are now allowed as Andrew
>> requested. Regarding dash, it could be allowed of course. But why isn't
>> "_" enough. I mean, I think it would be good to maintain allowed chars
>> within a limit.
>
>That's a personal style question. Is "fib-rules" less readable than
>"fib_rules"? Why put such limitations in place if there is no
>justifiable reason?

You mean any limitation?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3AC161C90
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 22:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgBQVDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 16:03:05 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42934 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbgBQVDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 16:03:04 -0500
Received: by mail-pl1-f195.google.com with SMTP id e8so7189508plt.9
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 13:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ELkDR22vOnk2EMyh6lZ2o2EgTEKCyjqr9cOt+NsucFc=;
        b=MoKrzZYvy3eX4RRSzB+sptEStuaFvIl1XRw1otldcbCpLdQw0D5mE9hGuOV8Ka4PQF
         ZEEPp0TqSuFYCz02SPhBmdmSAu3CuqY+cVnGccAxZegah+rfd5A1GRu6G+c37pltzg4S
         VSCj4oOABZrxgizSfISE18WTUbEVdf2xvKP/uSsOfzD4cXyNjFP6LwfB9uVQznWQFJLa
         hgIkByVdX7e7OHsXkThUKWFsi26a89l1IZmV2NreezhdhHwxCU8xEvjU+uAwwvDmPdYz
         gxxIp21LWQ7QaSHp9rDbkYddKCG27hedojKol6eUOG+Aj68DWK5O9e6UyqJOYwoTAAw/
         VbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ELkDR22vOnk2EMyh6lZ2o2EgTEKCyjqr9cOt+NsucFc=;
        b=WXUIOCJSqPzYW3IBaWgYePIqrhR0OcG7BsASwew5BLnPbDBfj7vah97B/xORiGq6ml
         7nlyzHnnmh5VRrBjy3VWyTIeRbeVFXWibqUuU02JarqKE/mlo+FIVDANSQqlH0QZv6eK
         mW7v9OngzI7rrmBmdco4efMRkZDzAo7kCSGoUOtJrcL081xflFymVqAvb+P6vGCvlD8X
         5E1BEXMDYBeZvG6jirF7r2IZQJOk6xFfwGw2mRYyaNlWZlc1xihGmN0hRaCBEB9eH+dS
         72xroms5fjOw7jHKPjDTiLnYp2Vq0UEtPB3d8EBB6XIjsPjz9weEep4RcTBpI0GYePgv
         5+mg==
X-Gm-Message-State: APjAAAVYH5sIMPgHcFUMPA1NQIvIFUN1sLG1CRvmILAVDdI0K3KBXhOK
        nCaxtNpgPHQXyFpilXpnzQLmog==
X-Google-Smtp-Source: APXvYqwL4IUEYtWCP7yrVfMaL1+mbRuRI+vSipt6X46kMueHdAyrTIuvzQZy/iHpFB7jserm3mCaAw==
X-Received: by 2002:a17:902:341:: with SMTP id 59mr18537943pld.29.1581973383776;
        Mon, 17 Feb 2020 13:03:03 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x197sm1380868pfc.1.2020.02.17.13.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 13:03:03 -0800 (PST)
Date:   Mon, 17 Feb 2020 13:02:55 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options
 support for erspan metadata
Message-ID: <20200217130255.06644553@hermes.lan>
In-Reply-To: <d0ec991a-77fc-84dd-b4cc-9ae649f7a0ac@gmail.com>
References: <cover.1581676056.git.lucien.xin@gmail.com>
        <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
        <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
        <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
        <20200214081324.48dc2090@hermes.lan>
        <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
        <20200214162104.04e0bb71@hermes.lan>
        <CADvbK_eSiGXuZqHAdQTJugLa7mNUkuQTDmcuVYMHO=1VB+Cs8w@mail.gmail.com>
        <793b8ff4-c04a-f962-f54f-3eae87a42963@gmail.com>
        <CADvbK_fOfEC0kG8wY_xbg_Yj4t=Y1oRKxo4h5CsYxN6Keo9YBQ@mail.gmail.com>
        <d0ec991a-77fc-84dd-b4cc-9ae649f7a0ac@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Feb 2020 12:53:14 -0700
David Ahern <dsahern@gmail.com> wrote:

> On 2/15/20 11:38 PM, Xin Long wrote:
> > On Sun, Feb 16, 2020 at 12:51 AM David Ahern <dsahern@gmail.com> wrote:  
> >>
> >> On 2/14/20 9:18 PM, Xin Long wrote:  
> >>> On Sat, Feb 15, 2020 at 8:21 AM Stephen Hemminger
> >>> <stephen@networkplumber.org> wrote:  
> >>>>
> >>>> On Sat, 15 Feb 2020 01:40:27 +0800
> >>>> Xin Long <lucien.xin@gmail.com> wrote:
> >>>>  
> >>>>> This's not gonna work. as the output will be:
> >>>>> {"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}  (string)
> >>>>> instead of
> >>>>> {"ver":2,"index":0,"dir":1,"hwid":2} (number)  
> >>>>
> >>>> JSON is typeless. Lots of values are already printed in hex  
> >>> You may mean JSON data itself is typeless.
> >>> But JSON objects are typed when parsing JSON data, which includes
> >>> string, number, array, boolean. So it matters how to define the
> >>> members' 'type' in JSON data.
> >>>
> >>> For example, in python's 'json' module:
> >>>
> >>> #!/usr/bin/python2
> >>> import json
> >>> json_data_1 = '{"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}'
> >>> json_data_2 = '{"ver":2,"index":0,"dir":1,"hwid":2}'
> >>> parsed_json_1 = (json.loads(json_data_1))
> >>> parsed_json_2 = (json.loads(json_data_2))
> >>> print type(parsed_json_1["hwid"])
> >>> print type(parsed_json_2["hwid"])
> >>>
> >>> The output is:
> >>> <type 'unicode'>
> >>> <type 'int'>
> >>>
> >>> Also, '{"result": true}' is different from '{"result": "true"}' when
> >>> loading it in a 3rd-party lib.
> >>>
> >>> I think the JSON data coming from iproute2 is designed to be used by
> >>> a 3rd-party lib to parse, not just to show to users. To keep these
> >>> members' original type (numbers) is more appropriate, IMO.
> >>>  
> >>
> >> Stephen: why do you think all of the numbers should be in hex?
> >>
> >> It seems like consistency with existing output should matter more.
> >> ip/link_gre.c for instance prints index as an int, version as an int,
> >> direction as a string and only hwid in hex.
> >>
> >> Xin: any reason you did not follow the output of the existingg netdev
> >> based solutions?  
> > Hi David,
> > 
> > Option is expressed as "version:index:dir:hwid", I made all fields
> > in this string of hex, just like "class:type:data" in:
> > 
> > commit 0ed5269f9e41f495c8e9020c85f5e1644c1afc57
> > Author: Simon Horman <simon.horman@netronome.com>
> > Date:   Tue Jun 26 21:39:37 2018 -0700
> > 
> >     net/sched: add tunnel option support to act_tunnel_key
> > 
> > I'm not sure if it's good to mix multiple types in this string. wdyt?
> > 
> > but for the JSON data, of course, these are all numbers(not string).
> >   
> 
> I don't understand why Stephen is pushing for hex; it does not make
> sense for version, index or direction. I don't have a clear
> understanding of hwid to know uint vs hex, so your current JSON prints
> seem fine.
> 
> As for the stdout print and hex fields, staring at the tc and lwtunnel
> code, it seems like those 2 have a lot of parallels in expressing
> options for encoding vs lwtunnel and netdev based code. ie., I think
> this latest set is correct.
> 
> Stephen?

I just wanted:
1. The parse and print functions should have the same formats.
I.e. if you take the output and do a little massaging of the ifindex
it should be accepted as an input set of parameters.

2. As much as possible, the JSON and non-JSON output should be similar.
If non-JSON prints in hex, then JSON should display hex and vice/versa.

Ideally all inputs would be human format (not machine formats like hex).
But I guess the mistake was already made with some of the other tunnels.

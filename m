Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE404AB20
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 21:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbfFRTog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 15:44:36 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44311 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfFRTog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 15:44:36 -0400
Received: by mail-lf1-f66.google.com with SMTP id r15so10196504lfm.11
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 12:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w5MhO3HOhnJdhEh1BKTn+Hy2Jia0mXD1Kokqqc9sG00=;
        b=ZulwLm573ji01DdOeRHyLoDmYWQ5Zhs0GbR+FScejbA7r82/8gew/YMdfC8M9srsq5
         JnJS2XXRJrPCk1cvRAJMAYxyG7j+iqz2rIgkskWqOPCU4bswLQn5Z6WyWudgSVV/1xJ5
         TR5u/tjfZTyfIhqcOuXqUgKotaoDP41/uZdhLQpe/vWYaanEh5YBOFg4rBAmX7bQ9FZy
         SJa0zPLJEQDu+HHBvXUo6Diduz9w/0YDO83xJ/XJARFChmEU5wJJd8u5vqlbTRLkFWdA
         0lWoJd004+VixJT7mStjF+u/5HHPXNkE4OzfsRH8Gi62JT8MjjFsAdIuTuV7TS6RCqEl
         ks+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w5MhO3HOhnJdhEh1BKTn+Hy2Jia0mXD1Kokqqc9sG00=;
        b=Ll6UB7YWR66ndfKr1av2UppPOEHRmh2nm/0wlH4Z+IR8YQcdvQrTn9wJ78G2pz2s20
         v+/tEBR+CcVEp/eigDuZHFYs6D+eOL4lOnRUtBN6ChChj5bkkRYKbvSo/IKVYlnCoino
         02ufJr2m6u3858lXJvKS9aDIT0sxRNj4T5coFOnIfni4ANH17Um6d/kELO35RVTjtjLR
         Ga271JlwuGLrxuEz1zugoRSf2Q4XVMcPgypkwVTi1GP2ymhqRh6Vj0cjIHHMfOx38HFk
         jJ6IWOQvYQnKhHJfxGipXQJtZW98vXOEgO9YDHgQLfME0xhjvuqFvUW40ZptXnVWr4Lk
         SVjg==
X-Gm-Message-State: APjAAAVdX/UsZ5SHSAfJB1QGjIyZQ0bKBwNDsdrt5vfybvYEmtIA30jq
        4XEx9u6QbUqvHOPukU941s2kkE1wSf9Nw+fiRg8w3wirQmY=
X-Google-Smtp-Source: APXvYqw7x1DqbvI1Md1RmNv8m+p9mIBRDeXizlRIzkOG8HjvjwMpgC6Iw1Qwf1t9FHYMcf1r+VEXqZI5pRPtyxEaeYw=
X-Received: by 2002:a19:7616:: with SMTP id c22mr5117066lff.115.1560887074523;
 Tue, 18 Jun 2019 12:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190524162229.9185-1-linus.walleij@linaro.org> <CAL_Jsq+bZsJ+SBiJa2hzXU9RkTNBhDk_Uv_Fk6V6DqRGh-xPRg@mail.gmail.com>
In-Reply-To: <CAL_Jsq+bZsJ+SBiJa2hzXU9RkTNBhDk_Uv_Fk6V6DqRGh-xPRg@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 18 Jun 2019 21:44:21 +0200
Message-ID: <CACRpkdbkwTtS2ofpxkZLERW-b+4=d7m9qiPXGT+iMemn9zZE1A@mail.gmail.com>
Subject: Re: [PATCH 7/8] net: ethernet: ixp4xx: Add DT bindings
To:     Rob Herring <robh@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 9:41 PM Rob Herring <robh@kernel.org> wrote:

> > +  reg:
> > +    maxItems: 1
> > +    description: Ethernet MMIO address range
> > +
> > +  queue-rx:
> > +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> > +    maxItems: 1
>
> This doesn't actually do what you think it is doing. A $ref plus
> additional constraints need to be under an 'allOf' list.
>
> > +    description: phandle to the RX queue on the NPE
>
> But this is a phandle plus 1 cell, right?
>
> - allOf:
>     - $ref: '/schemas/types.yaml#/definitions/phandle-array'
>     - items:
>         - items:
>             - description: phandle to the RX queue on the NPE
>             - description: whatever the cell contains
>               enum: [ 1, 2, 3, 4 ] # any constraints you can put on the cell
>
> This implicitly says you have 1 of a phandle + 1 cell.
>
> I need to add this to example-schema.yaml...

I just can't get this right :(

I have this:

  queue-rx:
    - allOf:
      - $ref: '/schemas/types.yaml#/definitions/phandle-array'
      - items:
        - items:
          - description: phandle to the RX queue on the NPE
          - description: index of the NPE engine RX queue to use
            enum: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]

I get this from dt_binding_check:

  CHKDT   Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml:
properties:queue-rx: [{'allOf': [{'$ref':
'/schemas/types.yaml#/definitions/phandle-array'}, {'items':
[{'items': [{'description': 'phandle to the RX queue on the NPE'},
{'description': 'index of the NPE engine RX queue to use', 'enum': [0,
1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}]}]}]}] is not of type 'object',
'boolean'
make[3]: *** [../Documentation/devicetree/bindings/Makefile:12:
Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.example.dts]
Error 1

Hm .... I just can't figure out what this recursive parsing thingie means...
I tried to update the pip3 repo but no cigar.

Any hints?

Yours,
Linus Walleij

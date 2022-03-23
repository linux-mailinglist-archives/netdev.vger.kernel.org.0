Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D20F4E4A54
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 02:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241045AbiCWBLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 21:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241031AbiCWBLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 21:11:34 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7AC6F4BB
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 18:10:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r13so39743297ejd.5
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 18:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Usl1cb51/8av9PlFaE8pZNe2bf5KKJvN2T2RDmfs+5U=;
        b=aHnC0nri4D5uQSk+Up+F9iO14ux5h+n+BlngUlSSFeHS/nBafyWB5cs4vZ93RjxRy2
         wJXhLNWWc4Sik01lxZUoXit/e8NGk9gmTwKIthzLrAuEpaZh/OXDTTV5kj4arkx5nlBV
         9lQ+a3b/01wBnY+xhOVsxRiB6sr0n+zL4SRu1X9Kk8Tid9zvjnlN/06+uOJfUpKf1D+a
         EyrESDwNVBpZnhUZMlSYX17D9zFLXFZx3X9SRPvtUYZlKfhl5VEftIoXXGtqluU9hmzs
         AhnTYmCOcYwIIpU0FxoE2e3NPn77ruuyWC/AdHP727WgZeNKirx17nssTJB6pquUPX5I
         FL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Usl1cb51/8av9PlFaE8pZNe2bf5KKJvN2T2RDmfs+5U=;
        b=GhGx7Ob9wHjQARRkaPr4QR4l5IVMEoEiP7Q4HFDkluOQ8VWUpt2dWAAZpScKPilOTO
         pjb1AzVwfS2XFTDhOCYearQ6wpuxg+r+DpUv7519OS+Au7a1BDoQ8m31FdyajjFRYiTX
         SnJv0BTaLTDN6AP07jWUcNUFZRWMO05QfNdzrEKsDY4A6PAa4NEz7Pv9wfncpN2BYX9y
         ikSfOAeU1BKxyJMSBK/eA+ZLurXE9FO64m/GYasLHxzUzhUGiqyeYlY86UpiGvxcfrC7
         hJ9MoXhNlD1PtnyjiL3MQBz3x6WHFsOpVTp2gaiTc8knxoqz0BQW43pxnL3Ai1w2PiMO
         b4rg==
X-Gm-Message-State: AOAM530W5anUGm1W/AXVKptxwPY5cxHK3ORjibY/w8cT5K6MNnw7ADSg
        zKDlaE++PaaLDo+qr876Uu1c1TMvk25mqgnlxMc=
X-Google-Smtp-Source: ABdhPJx2Fe0bZIuqd87mbasfgYXrFbgLcYQO3s8qk+AEOPZGfqexNtyVhVbs6oN/bUxTGEH4Qt7tzAlq7El+neeWNC0=
X-Received: by 2002:a17:907:c0c:b0:6d1:8c46:6415 with SMTP id
 ga12-20020a1709070c0c00b006d18c466415mr29543836ejc.326.1647997799095; Tue, 22
 Mar 2022 18:09:59 -0700 (PDT)
MIME-Version: 1.0
From:   Duke Abbaddon <duke.abbaddon@gmail.com>
Date:   Wed, 23 Mar 2022 01:09:50 +0000
Message-ID: <CAHpNFcN_tkiK1hO5HkJtvydLhj8biSLVQ+sFsuidM7wYF8PJPw@mail.gmail.com>
Subject: GPIO & QFFT : RS : Subject Re: [PATCH] watchdog: gpio_wdt: Support
 GPO lines with the toggle algorithm
To:     torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GPIO is used for Super speed output, However Serialised Parallel
processing allows constant flow:

Examples:

Audio devices such as creative logic ISA & PCI Cards on SUPER
input mode (Mic & Input ports)16Bit HQ into 256 Drums in 32Bit Super HQ

CPU Coprocessors such as the QFFT : Input & Output alternate lines on pins

Parallel ports in Super IO mode! 4MB/S WOW

Hard Drives IO 120MB/s Write Cycle (Audio Recording Desks & Studio
Recording Studios)

Tape DECKS : IBM, Fuji, Sony & Samsung TAPE Backups Super IO GPIO :
1.2GB/s to 72GB/s Compressed

GPIO Could be used on RAM : Examples is 4 special pins on the RAM for
burst mode!

GPIO is rather more relevant than you think!

Rupert S

https://science.n-helix.com/2021/11/wave-focus-anc.html

https://science.n-helix.com/2021/10/noise-violation-technology-bluetooth.ht=
ml


https://www.orosound.com/

https://www.consumerreports.org/noise-canceling-headphone/best-noise-cancel=
ing-headphones-of-the-year-a1166868524/


https://lkml.org/lkml/2022/3/22/1112

Date Tue, 22 Mar 2022 17:04:53 -0700
From Guenter Roeck <>
Subject Re: [PATCH] watchdog: gpio_wdt: Support GPO lines with the
toggle algorithm
share 0
On 3/22/22 15:29, Tobias Waldekranz wrote:
> Support using GPO lines (i.e. GPIOs that are output-only) with
> gpio_wdt using the "toggle" algorithm.
>
> Since its inception, gpio_wdt has configured its GPIO line as an input
> when using the "toggle" algorithm, even though it is used as an output
> when kicking. This needlessly barred hardware with output-only pins
> from using the driver.
>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>
> Hi,
>
> This patch has been in our downstream tree for a long time. We need it
> because our kick GPIO can't be used as an input.
>
> What I really can't figure out is why the driver would request the pin
> as in input, when it's always going to end up being used as an output
> anyway.
>
> So I thought I'd send it upstream in the hopes of either getting it
> merged, or an explanation as to why it is needed.
>

I _think_ the assumption / idea was that "toggle" implies that the output
is connected to a pull-up resistor and that the pin either floats or is
pulled down to ground, causing the signal to toggle. I don't know if/how
that works in practice, though.

Guenter

>   drivers/watchdog/gpio_wdt.c | 13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/watchdog/gpio_wdt.c b/drivers/watchdog/gpio_wdt.c
> index 0923201ce874..f7686688e0e2 100644
> --- a/drivers/watchdog/gpio_wdt.c
> +++ b/drivers/watchdog/gpio_wdt.c
> @@ -108,7 +108,6 @@ static int gpio_wdt_probe(struct platform_device *pde=
v)
>   struct device *dev =3D &pdev->dev;
>   struct device_node *np =3D dev->of_node;
>   struct gpio_wdt_priv *priv;
> - enum gpiod_flags gflags;
>   unsigned int hw_margin;
>   const char *algo;
>   int ret;
> @@ -122,17 +121,15 @@ static int gpio_wdt_probe(struct platform_device *p=
dev)
>   ret =3D of_property_read_string(np, "hw_algo", &algo);
>   if (ret)
>   return ret;
> - if (!strcmp(algo, "toggle")) {
> +
> + if (!strcmp(algo, "toggle"))
>   priv->hw_algo =3D HW_ALGO_TOGGLE;
> - gflags =3D GPIOD_IN;
> - } else if (!strcmp(algo, "level")) {
> + else if (!strcmp(algo, "level"))
>   priv->hw_algo =3D HW_ALGO_LEVEL;
> - gflags =3D GPIOD_OUT_LOW;
> - } else {
> + else
>   return -EINVAL;
> - }
>
> - priv->gpiod =3D devm_gpiod_get(dev, NULL, gflags);
> + priv->gpiod =3D devm_gpiod_get(dev, NULL, GPIOD_OUT_LOW);
>   if (IS_ERR(priv->gpiod))
>   return PTR_ERR(priv->gpiod);
>

*****

Get the best out of Youtube encoding with GPL QFFT Codecs for :
Windows,Linux & Android #RockTheHouseGoogle!

Advanced FFT & 3D Audio functions for CPU & GPU
https://gpuopen.com/true-audio-next/

Multimedia Codec SDK https://gpuopen.com/advanced-media-framework/

(c)Rupert S https://science.n-helix.com

***
Decoder CB 2021 Codecs

kAudioDecoderName "FFmpegAudioDecoder"
kAudioTracks [{"bytes per channel":2,"bytes per frame":4,"channel
layout":"STEREO","channels":2,"codec":"aac","codec delay":0,"discard
decoder delay":false,"encryption scheme":"Unencrypted","has extra
data":false,"profile":"unknown","sample format":"Signed
16-bit","samples per second":48000,"seek preroll":"0us"}]

kVideoDecoderName "MojoVideoDecoder"
kVideoPlaybackFreezing 0.10006
kVideoPlaybackRoughness 3.048
kVideoTracks [{"alpha mode":"is_opaque","codec":"h264","coded
size":"426x240","color space":"{primaries:BT709, transfer:BT709,
matrix:BT709, range:LIMITED}","encryption scheme":"Unencrypted","has
extra data":false,"hdr metadata":"unset","natural
size":"426x240","orientation":"0=C2=B0","profile":"h264 baseline","visible
rect":"0,0 426x240"}]

info "Selected FFmpegAudioDecoder for audio decoding, config: codec:
mp3, profile: unknown, bytes_per_channel: 2, channel_layout: STEREO,
channels: 2, samples_per_second: 44100, sample_format: Signed 16-bit
planar, bytes_per_frame: 4, seek_preroll: 0us, codec_delay: 0, has
extra data: false, encryption scheme: Unencrypted, discard decoder
delay: true"
kAudioDecoderName "FFmpegAudioDecoder"
kAudioTracks [{"bytes per channel":2,"bytes per frame":4,"channel
layout":"STEREO","channels":2,"codec":"mp3","codec delay":0,"discard
decoder delay":true,"encryption scheme":"Unencrypted","has extra
data":false,"profile":"unknown","sample format":"Signed 16-bit
planar","samples per second":44100,"seek preroll":"0us"}]
kBitrate 192000

kAudioDecoderName "FFmpegAudioDecoder"
kAudioTracks [{"bytes per channel":4,"bytes per frame":8,"channel
layout":"STEREO","channels":2,"codec":"opus","codec
delay":312,"discard decoder delay":true,"encryption
scheme":"Unencrypted","has extra
data":true,"profile":"unknown","sample format":"Float 32-bit","samples
per second":48000,"seek preroll":"80000us"}]

kVideoDecoderName "VpxVideoDecoder"
kVideoTracks [{"alpha mode":"is_opaque","codec":"vp9","coded
size":"1920x1080","color space":"{primaries:BT709, transfer:BT709,
matrix:BT709, range:LIMITED}","encryption scheme":"Unencrypted","has
extra data":false,"hdr metadata":"unset","natural
size":"1920x1080","orientation":"0=C2=B0","profile":"vp9 profile0","visible
rect":"0,0 1920x1080"}]

kAudioDecoderName "FFmpegAudioDecoder"
kAudioTracks [{"bytes per channel":2,"bytes per frame":4,"channel
layout":"STEREO","channels":2,"codec":"aac","codec delay":0,"discard
decoder delay":false,"encryption scheme":"Unencrypted","has extra
data":false,"profile":"unknown","sample format":"Signed
16-bit","samples per second":44100,"seek preroll":"0us"}]

kVideoDecoderName "MojoVideoDecoder"
kVideoTracks [{"alpha mode":"is_opaque","codec":"h264","coded
size":"1920x1080","color space":"{primaries:BT709, transfer:BT709,
matrix:BT709, range:LIMITED}","encryption scheme":"Unencrypted","has
extra data":false,"hdr metadata":"unset","natural
size":"1920x1080","orientation":"0=C2=B0","profile":"h264 main","visible
rect":"0,0 1920x1080"}]
***

PlayStation 5 and Xbox Series Spatial Audio Comparison | Technalysis
Audio 3D Tested : Tempest,ATMOS,DTX,DTS

https://www.youtube.com/watch?v=3DvsC2orqiCwI

*

Waves & Shape FFT original QFFT Audio device & CPU/GPU : (c)RS

The use of an FFT simple unit to output directly: Sound
& other content such as a BLENDER or DAC Content : (c)RS

FFT Examples :

Analogue smoothed audio ..
Using a capacitor on the pin output to a micro diode laser (for analogue Fi=
bre)

Digital output using:
8 to 128Bit multiple high frequency burst mode..

(Multi Phase step at higher frequency & smooth interpolation)
Analogue wave converted to digital in key steps through a DAC at
higher frequency & amplitude.

For many systems an analogue wave makes sense when high speed crystal
digital is too expensive.

Multiple frequency overlapped digital signals with a time formula is
also possible.

The mic works by calculating angle on a drum...
Light.. and timing & dispersion...
The audio works by QFFT replication of audio function..
The DAC works by quantifying as Analog digital or Metric Matrix..
The CPU/GPU by interpreting the data of logic, Space & timing...

We need to calculate Quantum is not the necessary feature;

But it is the highlight of our:
Data storage cache.
Our Temporary RAM
Our Data transport..
Of our fusion future.

FFT & fast precise wave operations in SiMD

Several features included for Audio & Video : Add to Audio & Video
drivers & sdk i love you <3 DL

In particular I want Bluetooth audio optimized with SiMD,AVX vector
instructions & DSP process drivers..

The opportunity presents itself to improve the DAC; In particular of
the Video cards & Audio devices & HardDrives & BDBlueRay Player Record
& load functions of the fluctuating laser..
More than that FFT is logical and fast; Precise & adaptive; FP & SiMD
present these opportunities with correct FFT operations & SDK's.

3D surround optimised the same, In particular with FFT efficient code,
As one imagines video is also effected by FFT ..

Video colour & representation & wavelet compression & sharpness restoration=
..
Vivid presentation of audio & video & 3D objects and texture; For
example DOT compression & image,Audio presentation...

SSD & HD technology presents unique opportunities for magnetic waves
and amplitude speculation & presentation.

FFT : FMA : SiMD instructions & speed : application examples : Audio,
Colour pallet , Rainbows, LUT, Blood corpuscles with audio & vibration
interaction, Rain with environmental effects & gravity.. There are
many application examples of transforms in action (More and more
complex by example)

High performance SIMD modular arithmetic for polynomial evaluation

FFT Examples :  in the SiMD Folder...

Evaluation of FFT and polynomial X array algebra .. is here handled to
over 50Bits...
As we understand it the maths depends on a 64bit value with a 128Bit  ..
as explained in the article value have to be in identical ranges bit
wise, However odd bit depth sizes are non conforming (God i need
coffee!)

In one example (page 9) Most of the maths is 64Bit & One value 128Bit
"We therefore focus in this article on the use of floating-point (FP)
FMA (fused multiply-add) instructions for floating-point based modular
arithmetic. Since the FMA instruction performs two operations (a =E2=88=97 =
b +
c) with one single final rounding, it can indeed be used to design a
fast error-free transformation of the product of two floating-point
numbers"

Our latest addition is a quite detailed example for us
High performance SIMD modular arithmetic for
polynomial evaluation 2020

Pierre Fortin, Ambroise Fleury, Fran=C3=A7ois Lemaire, Michael Monagan

https://hal.archives-ouvertes.fr/hal-02552673/document

Contains multiple algorithm examples & is open about the computer
operations in use.

Advanced FFT & 3D Audio functions for CPU & GPU
https://gpuopen.com/true-audio-next/

Multimedia Codec SDK https://gpuopen.com/advanced-media-framework/

(c)Rupert S https://science.n-helix.com

*****

Lets face it, Realtec could well resource the QFFT Audio device &
transformer/DAC

(c)Rupert S https://science.n-helix.com

document work examples :

https://eurekalert.org/pub_releases/2021-01/epfd-lpb010621.php

"Light-based processors boost machine-learning processing
ECOLE POLYTECHNIQUE F=C3=89D=C3=89RALE DE LAUSANNE

Research News

IMAGE
IMAGE: SCHEMATIC REPRESENTATION OF A PROCESSOR FOR MATRIX
MULTIPLICATIONS WHICH RUNS ON LIGHT. view more

CREDIT: UNIVERSITY OF OXFORD

The exponential growth of data traffic in our digital age poses some
real challenges on processing power. And with the advent of machine
learning and AI in, for example, self-driving vehicles and speech
recognition, the upward trend is set to continue. All this places a
heavy burden on the ability of current computer processors to keep up
with demand.

Now, an international team of scientists has turned to light to tackle
the problem. The researchers developed a new approach and architecture
that combines processing and data storage onto a single chip by using
light-based, or "photonic" processors, which are shown to surpass
conventional electronic chips by processing information much more
rapidly and in parallel.

The scientists developed a hardware accelerator for so-called
matrix-vector multiplications, which are the backbone of neural
networks (algorithms that simulate the human brain), which themselves
are used for machine-learning algorithms. Since different light
wavelengths (colors) don't interfere with each other, the researchers
could use multiple wavelengths of light for parallel calculations. But
to do this, they used another innovative technology, developed at
EPFL, a chip-based "frequency comb", as a light source.

"Our study is the first to apply frequency combs in the field of
artificially neural networks," says Professor Tobias Kippenberg at
EPFL, one the study's leads. Professor Kippenberg's research has
pioneered the development of frequency combs. "The frequency comb
provides a variety of optical wavelengths that are processed
independently of one another in the same photonic chip."

"Light-based processors for speeding up tasks in the field of machine
learning enable complex mathematical tasks to be processed at high
speeds and throughputs," says senior co-author Wolfram Pernice at
M=C3=BCnster University, one of the professors who led the research. "This
is much faster than conventional chips which rely on electronic data
transfer, such as graphic cards or specialized hardware like TPU's
(Tensor Processing Unit)."

After designing and fabricating the photonic chips, the researchers
tested them on a neural network that recognizes of hand-written
numbers. Inspired by biology, these networks are a concept in the
field of machine learning and are used primarily in the processing of
image or audio data. "The convolution operation between input data and
one or more filters - which can identify edges in an image, for
example, are well suited to our matrix architecture," says Johannes
Feldmann, now based at the University of Oxford Department of
Materials. Nathan Youngblood (Oxford University) adds: "Exploiting
wavelength multiplexing permits higher data rates and computing
densities, i.e. operations per area of processor, not previously
attained."

"This work is a real showcase of European collaborative research,"
says David Wright at the University of Exeter, who leads the EU
project FunComp, which funded the work. "Whilst every research group
involved is world-leading in their own way, it was bringing all these
parts together that made this work truly possible."

The study is published in Nature this week, and has far-reaching
applications: higher simultaneous (and energy-saving) processing of
data in artificial intelligence, larger neural networks for more
accurate forecasts and more precise data analysis, large amounts of
clinical data for diagnoses, enhancing rapid evaluation of sensor data
in self-driving vehicles, and expanding cloud computing
infrastructures with more storage space, computing power, and
applications software.

###

Reference

J. Feldmann, N. Youngblood, M. Karpov, H. Gehring, X. Li, M. Stappers,
M. Le Gallo, X. Fu, A. Lukashchuk, A.S. Raja, J. Liu, C.D. Wright, A.
Sebastian, T.J. Kippenberg, W.H.P. Pernice, H. Bhaskaran. Parallel
convolution processing using an integrated photonic tensor core.
Nature 07 January 2021. DOI: 10.1038/s41586-020-03070-1"

Time Measurement

"Let's Play" Station NitroMagika_LightCaster

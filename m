Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A5F2644CC
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 12:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgIJK4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 06:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730604AbgIJKxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 06:53:23 -0400
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1CE221D6C;
        Thu, 10 Sep 2020 10:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599735202;
        bh=426DpA/GVvBchbCt06SpJGjKU4je/b+dpqllLf+JSR8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=0V/e/wz1WenVmC3pPaGFBHAG/lV6TCw7GufciP4TkPqRCrKXD3PaFc+keE0TVmYpO
         76fSGs6njLQh7PZ0I7aXGhNddj1O7NSuxz62HPYrd/HV3MldvZVYMAnf9sW7+yMEVP
         dJ9JqVaroKHlr3UI74JE3IE0+KZY/lARcC/6l09M=
Received: by mail-ej1-f46.google.com with SMTP id z22so8016890ejl.7;
        Thu, 10 Sep 2020 03:53:21 -0700 (PDT)
X-Gm-Message-State: AOAM532ndb6fn6dvJK+d+byCcdnNk1gSqIi4f9PnlThyGlKdWWkkFFXt
        RldEvRUGSZhxVv3Db8qW7fYgCtC9H2uAOsc+hqI=
X-Google-Smtp-Source: ABdhPJxuiAoiRqYvlmScHBYbVBWNtkR54i9+ci/6nlyH6E1t5+auTks3zPtO7XvjIZZjtpRLYuxY1yLuT2dJygU0JIk=
X-Received: by 2002:a17:906:af53:: with SMTP id ly19mr7845762ejb.503.1599735200004;
 Thu, 10 Sep 2020 03:53:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200906153654.2925-1-krzk@kernel.org> <20200906153654.2925-2-krzk@kernel.org>
 <20200908194520.GA786466@bogus>
In-Reply-To: <20200908194520.GA786466@bogus>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Thu, 10 Sep 2020 12:53:07 +0200
X-Gmail-Original-Message-ID: <CAJKOXPeexek3Dq1Ly6z=PO51ULTWy+v13i-NDQm-Mz8YAET+iA@mail.gmail.com>
Message-ID: <CAJKOXPeexek3Dq1Ly6z=PO51ULTWy+v13i-NDQm-Mz8YAET+iA@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] dt-bindings: net: nfc: s3fwrn5: Convert to dtschema
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-nfc@lists.01.org,
        "David S. Miller" <davem@davemloft.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Rob Herring <robh+dt@kernel.org>,
        Will Deacon <will@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Sep 2020 at 21:45, Rob Herring <robh@kernel.org> wrote:
>
> On Sun, 06 Sep 2020 17:36:46 +0200, Krzysztof Kozlowski wrote:
> > Convert the Samsung S3FWRN5 NCI NFC controller bindings to dtschema.
> > This is conversion only so it includes properties with invalid prefixes
> > (s3fwrn5,en-gpios) which should be addressed later.
> >
> > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > ---
> >  .../devicetree/bindings/net/nfc/s3fwrn5.txt   | 25 --------
> >  .../bindings/net/nfc/samsung,s3fwrn5.yaml     | 61 +++++++++++++++++++
> >  MAINTAINERS                                   |  1 +
> >  3 files changed, 62 insertions(+), 25 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn5.t=
xt
> >  create mode 100644 Documentation/devicetree/bindings/net/nfc/samsung,s=
3fwrn5.yaml
> >
>
>
> My bot found errors running 'make dt_binding_check' on your patch:
>
> ./Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml: $id: re=
lative path/filename doesn't match actual path or filename
>         expected: http://devicetree.org/schemas/net/nfc/samsung,s3fwrn5.y=
aml#
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/=
nfc/samsung,s3fwrn5.example.dt.yaml: s3fwrn5@27: 's3fwrn5,en-gpios', 's3fwr=
n5,fw-gpios' do not match any of the regexes: '^#.*', '^(at25|devbus|dmacap=
|dsa|exynos|fsi[ab]|gpio-fan|gpio|gpmc|hdmi|i2c-gpio),.*', '^(keypad|m25p|m=
ax8952|max8997|max8998|mpmc),.*', '^(pinctrl-single|#pinctrl-single|PowerPC=
),.*', '^(pl022|pxa-mmc|rcar_sound|rotary-encoder|s5m8767|sdhci),.*', '^(si=
mple-audio-card|st-plgpio|st-spics|ts),.*', '^70mai,.*', '^GEFanuc,.*', '^O=
RCL,.*', '^SUNW,.*', '^[a-zA-Z0-9#_][a-zA-Z0-9+\\-._@]{0,63}$', '^[a-zA-Z0-=
9+\\-._]*@[0-9a-zA-Z,]*$', '^abilis,.*', '^abracon,.*', '^acer,.*', '^acme,=
.*', '^actions,.*', '^active-semi,.*', '^ad,.*', '^adafruit,.*', '^adapteva=
,.*', '^adaptrum,.*', '^adh,.*', '^adi,.*', '^advantech,.*', '^aeroflexgais=
ler,.*', '^al,.*', '^allegro,.*', '^allo,.*', '^allwinner,.*', '^alphascale=
,.*', '^alps,.*', '^altr,.*', '^amarula,.*', '^amazon,.*', '^amcc,.*', '^am=
d,.*', '^amediatech,.*', '^amlogic,.*', '^ampire,.*', '^ams,.*', '^amstaos,=
.*', '^analogix,.*', '^andestech,.*', '^anvo,.*', '^apm,.*', '^aptina,.*', =
'^arasan,.*', '^archermind,.*', '^arctic,.*', '^arcx,.*', '^aries,.*', '^ar=
m,.*', '^armadeus,.*', '^arrow,.*', '^artesyn,.*', '^asahi-kasei,.*', '^asc=
,.*', '^aspeed,.*', '^asus,.*', '^atlas,.*', '^atmel,.*', '^auo,.*', '^auvi=
dea,.*', '^avago,.*', '^avia,.*', '^avic,.*', '^avnet,.*', '^awinic,.*', '^=
axentia,.*', '^axis,.*', '^azoteq,.*', '^azw,.*', '^baikal,.*', '^bananapi,=
.*', '^beacon,.*', '^beagle,.*', '^bhf,.*', '^bitmain,.*', '^boe,.*', '^bos=
ch,.*', '^boundary,.*', '^brcm,.*', '^broadmobi,.*', '^bticino,.*', '^buffa=
lo,.*', '^bur,.*', '^calaosystems,.*', '^calxeda,.*', '^capella,.*', '^casc=
oda,.*', '^catalyst,.*', '^cavium,.*', '^cdns,.*', '^cdtech,.*', '^cellwise=
,.*', '^ceva,.*', '^checkpoint,.*', '^chipidea,.*', '^chipone,.*', '^chipsp=
ark,.*', '^chrontel,.*', '^chrp,.*', '^chunghwa,.*', '^chuwi,.*', '^ciaa,.*=
', '^cirrus,.*', '^cloudengines,.*', '^cnm,.*', '^cnxt,.*', '^colorfly,.*',=
 '^compulab,.*', '^coreriver,.*', '^corpro,.*', '^cortina,.*', '^cosmic,.*'=
, '^crane,.*', '^creative,.*', '^crystalfontz,.*', '^csky,.*', '^csq,.*', '=
^cubietech,.*', '^cypress,.*', '^cznic,.*', '^dallas,.*', '^dataimage,.*', =
'^davicom,.*', '^dell,.*', '^delta,.*', '^denx,.*', '^devantech,.*', '^dh,.=
*', '^difrnce,.*', '^digi,.*', '^digilent,.*', '^dioo,.*', '^dlc,.*', '^dlg=
,.*', '^dlink,.*', '^dmo,.*', '^domintech,.*', '^dongwoon,.*', '^dptechnics=
,.*', '^dragino,.*', '^dserve,.*', '^dynaimage,.*', '^ea,.*', '^ebs-systart=
,.*', '^ebv,.*', '^eckelmann,.*', '^edt,.*', '^eeti,.*', '^einfochips,.*', =
'^elan,.*', '^elgin,.*', '^elida,.*', '^embest,.*', '^emlid,.*', '^emmicro,=
.*', '^empire-electronix,.*', '^emtrion,.*', '^endless,.*', '^ene,.*', '^en=
ergymicro,.*', '^engicam,.*', '^epcos,.*', '^epfl,.*', '^epson,.*', '^esp,.=
*', '^est,.*', '^ettus,.*', '^eukrea,.*', '^everest,.*', '^everspin,.*', '^=
evervision,.*', '^exar,.*', '^excito,.*', '^ezchip,.*', '^facebook,.*', '^f=
airphone,.*', '^faraday,.*', '^fastrax,.*', '^fcs,.*', '^feixin,.*', '^feiy=
ang,.*', '^firefly,.*', '^focaltech,.*', '^frida,.*', '^friendlyarm,.*', '^=
fsl,.*', '^fujitsu,.*', '^gardena,.*', '^gateworks,.*', '^gcw,.*', '^ge,.*'=
, '^geekbuying,.*', '^gef,.*', '^gemei,.*', '^geniatech,.*', '^giantec,.*',=
 '^giantplus,.*', '^globalscale,.*', '^globaltop,.*', '^gmt,.*', '^goodix,.=
*', '^google,.*', '^grinn,.*', '^grmn,.*', '^gumstix,.*', '^gw,.*', '^hanns=
tar,.*', '^haoyu,.*', '^hardkernel,.*', '^hideep,.*', '^himax,.*', '^hisili=
con,.*', '^hit,.*', '^hitex,.*', '^holt,.*', '^holtek,.*', '^honeywell,.*',=
 '^hoperun,.*', '^hp,.*', '^hsg,.*', '^hugsun,.*', '^hwacom,.*', '^hydis,.*=
', '^hyundai,.*', '^i2se,.*', '^ibm,.*', '^icplus,.*', '^idt,.*', '^ifi,.*'=
, '^ilitek,.*', '^img,.*', '^imi,.*', '^incircuit,.*', '^inet-tek,.*', '^in=
fineon,.*', '^inforce,.*', '^ingenic,.*', '^innolux,.*', '^inside-secure,.*=
', '^inspur,.*', '^intel,.*', '^intercontrol,.*', '^invensense,.*', '^inver=
sepath,.*', '^iom,.*', '^isee,.*', '^isil,.*', '^issi,.*', '^ite,.*', '^ite=
ad,.*', '^ivo,.*', '^iwave,.*', '^jdi,.*', '^jedec,.*', '^jesurun,.*', '^ji=
anda,.*', '^kam,.*', '^karo,.*', '^keithkoep,.*', '^keymile,.*', '^khadas,.=
*', '^kiebackpeter,.*', '^kinetic,.*', '^kingdisplay,.*', '^kingnovel,.*', =
'^kionix,.*', '^kobo,.*', '^koe,.*', '^kontron,.*', '^kosagi,.*', '^kyo,.*'=
, '^lacie,.*', '^laird,.*', '^lamobo,.*', '^lantiq,.*', '^lattice,.*', '^le=
adtek,.*', '^leez,.*', '^lego,.*', '^lemaker,.*', '^lenovo,.*', '^lg,.*', '=
^lgphilips,.*', '^libretech,.*', '^licheepi,.*', '^linaro,.*', '^linksprite=
,.*', '^linksys,.*', '^linutronix,.*', '^linux,.*', '^linx,.*', '^lltc,.*',=
 '^logicpd,.*', '^logictechno,.*', '^longcheer,.*', '^loongson,.*', '^lsi,.=
*', '^lwn,.*', '^lxa,.*', '^macnica,.*', '^mapleboard,.*', '^marvell,.*', '=
^maxbotix,.*', '^maxim,.*', '^mbvl,.*', '^mcube,.*', '^meas,.*', '^mecer,.*=
', '^mediatek,.*', '^megachips,.*', '^mele,.*', '^melexis,.*', '^melfas,.*'=
, '^mellanox,.*', '^memsic,.*', '^menlo,.*', '^merrii,.*', '^micrel,.*', '^=
microchip,.*', '^microcrystal,.*', '^micron,.*', '^microsoft,.*', '^mikroe,=
.*', '^mikrotik,.*', '^miniand,.*', '^minix,.*', '^miramems,.*', '^mitsubis=
hi,.*', '^mosaixtech,.*', '^motorola,.*', '^moxa,.*', '^mpl,.*', '^mps,.*',=
 '^mqmaker,.*', '^mrvl,.*', '^mscc,.*', '^msi,.*', '^mstar,.*', '^mti,.*', =
'^multi-inno,.*', '^mundoreader,.*', '^murata,.*', '^mxicy,.*', '^myir,.*',=
 '^national,.*', '^nec,.*', '^neonode,.*', '^netgear,.*', '^netlogic,.*', '=
^netron-dy,.*', '^netxeon,.*', '^neweast,.*', '^newhaven,.*', '^nexbox,.*',=
 '^nextthing,.*', '^ni,.*', '^nintendo,.*', '^nlt,.*', '^nokia,.*', '^nordi=
c,.*', '^novtech,.*', '^nutsboard,.*', '^nuvoton,.*', '^nvd,.*', '^nvidia,.=
*', '^nxp,.*', '^oceanic,.*', '^okaya,.*', '^oki,.*', '^olimex,.*', '^olpc,=
.*', '^onion,.*', '^onnn,.*', '^ontat,.*', '^opalkelly,.*', '^opencores,.*'=
, '^openrisc,.*', '^option,.*', '^oranth,.*', '^orisetech,.*', '^ortustech,=
.*', '^osddisplays,.*', '^overkiz,.*', '^ovti,.*', '^oxsemi,.*', '^ozzmaker=
,.*', '^panasonic,.*', '^parade,.*', '^parallax,.*', '^pda,.*', '^pericom,.=
*', '^pervasive,.*', '^phicomm,.*', '^phytec,.*', '^picochip,.*', '^pine64,=
.*', '^pineriver,.*', '^pixcir,.*', '^plantower,.*', '^plathome,.*', '^plda=
,.*', '^plx,.*', '^pni,.*', '^pocketbook,.*', '^polaroid,.*', '^portwell,.*=
', '^poslab,.*', '^pov,.*', '^powervr,.*', '^primux,.*', '^probox2,.*', '^p=
rt,.*', '^pulsedlight,.*', '^purism,.*', '^qca,.*', '^qcom,.*', '^qemu,.*',=
 '^qi,.*', '^qiaodian,.*', '^qihua,.*', '^qnap,.*', '^radxa,.*', '^raidsoni=
c,.*', '^ralink,.*', '^ramtron,.*', '^raspberrypi,.*', '^raydium,.*', '^rda=
,.*', '^realtek,.*', '^renesas,.*', '^rervision,.*', '^richtek,.*', '^ricoh=
,.*', '^rikomagic,.*', '^riscv,.*', '^rockchip,.*', '^rocktech,.*', '^rohm,=
.*', '^ronbo,.*', '^roofull,.*', '^samsung,.*', '^samtec,.*', '^sancloud,.*=
', '^sandisk,.*', '^satoz,.*', '^sbs,.*', '^schindler,.*', '^seagate,.*', '=
^seirobotics,.*', '^semtech,.*', '^sensirion,.*', '^sensortek,.*', '^sff,.*=
', '^sgd,.*', '^sgmicro,.*', '^sgx,.*', '^sharp,.*', '^shimafuji,.*', '^shi=
ratech,.*', '^si-en,.*', '^si-linux,.*', '^sifive,.*', '^sigma,.*', '^sii,.=
*', '^sil,.*', '^silabs,.*', '^silead,.*', '^silergy,.*', '^silex-insight,.=
*', '^siliconmitus,.*', '^simtek,.*', '^sinlinx,.*', '^sinovoip,.*', '^sipe=
ed,.*', '^sirf,.*', '^sis,.*', '^sitronix,.*', '^skyworks,.*', '^smartlabs,=
.*', '^smsc,.*', '^snps,.*', '^sochip,.*', '^socionext,.*', '^solidrun,.*',=
 '^solomon,.*', '^sony,.*', '^spansion,.*', '^sprd,.*', '^sst,.*', '^sstar,=
.*', '^st,.*', '^st-ericsson,.*', '^starry,.*', '^startek,.*', '^ste,.*', '=
^stericsson,.*', '^summit,.*', '^sunchip,.*', '^swir,.*', '^syna,.*', '^syn=
ology,.*', '^tbs,.*', '^tbs-biometrics,.*', '^tcg,.*', '^tcl,.*', '^technex=
ion,.*', '^technologic,.*', '^techstar,.*', '^tempo,.*', '^terasic,.*', '^t=
fc,.*', '^thine,.*', '^thingyjp,.*', '^ti,.*', '^tianma,.*', '^tlm,.*', '^t=
mt,.*', '^topeet,.*', '^toppoly,.*', '^topwise,.*', '^toradex,.*', '^toshib=
a,.*', '^toumaz,.*', '^tpk,.*', '^tplink,.*', '^tpo,.*', '^tq,.*', '^tronfy=
,.*', '^tronsmart,.*', '^truly,.*', '^tsd,.*', '^tyan,.*', '^u-blox,.*', '^=
u-boot,.*', '^ubnt,.*', '^ucrobotics,.*', '^udoo,.*', '^ugoos,.*', '^uniwes=
t,.*', '^upisemi,.*', '^urt,.*', '^usi,.*', '^utoo,.*', '^v3,.*', '^vaisala=
,.*', '^vamrs,.*', '^variscite,.*', '^via,.*', '^videostrong,.*', '^virtio,=
.*', '^vishay,.*', '^visionox,.*', '^vitesse,.*', '^vivante,.*', '^vocore,.=
*', '^voipac,.*', '^vot,.*', '^vxt,.*', '^waveshare,.*', '^wd,.*', '^we,.*'=
, '^wetek,.*', '^wexler,.*', '^whwave,.*', '^wi2wi,.*', '^winbond,.*', '^wi=
nstar,.*', '^wits,.*', '^wlf,.*', '^wm,.*', '^wobo,.*', '^x-powers,.*', '^x=
es,.*', '^xiaomi,.*', '^xillybus,.*', '^xingbangda,.*', '^xinpeng,.*', '^xl=
nx,.*', '^xnano,.*', '^xunlong,.*', '^xylon,.*', '^ylm,.*', '^yna,.*', '^yo=
nes-toptech,.*', '^ysoft,.*', '^zarlink,.*', '^zeitec,.*', '^zidoo,.*', '^z=
ii,.*', '^zte,.*', '^zyxel,.*'
>         From schema: /builds/robherring/linux-dt-review/Documentation/dev=
icetree/bindings/vendor-prefixes.yaml

 My bad, I'll send v3.

Best regards,
Krzysztof
